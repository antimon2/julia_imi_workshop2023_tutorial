### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ cbcd0d61-6ca8-42f5-8ec3-9d6c7efb7530
using BenchmarkTools

# ╔═╡ 81faba57-dc86-48c9-a53d-806db4a4d7cb
versioninfo()

# ╔═╡ c64be533-3b1a-4d7e-be35-e934ee9ee18c
md"""
# スレッド並列の基礎
"""

# ╔═╡ 5512d5ab-d27e-48ad-8adb-6eba75efa144
md"""
## Juliaにおけるスレッド並列の基本
"""

# ╔═╡ d14ab956-11d8-4811-ac52-ea4c0c53c7be
md"""
### 最低限の事前準備
"""

# ╔═╡ ce550b07-87b2-464e-b483-e0651cab18c0
md"""
```bash
> julia -t 4  # 最大スレッド数は4

> julia -t auto  # 確保できる分だけスレッド数を確保

> env JULIA_NUM_THREADS=XXX julia  # Bash/Zsh などで環境変数指定と同時にJulia起動
```
"""

# ╔═╡ 10b6a16c-27c8-4881-b77f-bb57935d33c6
Threads.nthreads()

# ╔═╡ bcdba047-5543-4fcf-b9cc-702dbb8241f7
md"""
### 各種API（1） `@threads`
"""

# ╔═╡ 2f78aaec-0909-11ee-06c4-dfb316a8d214
Threads.nthreads()

# ╔═╡ f72a18c7-378e-478c-9743-3cc61179ea5d
fib(n) = n ≤ 1 ? n : fib(n - 2) + fib(n - 1)

# ╔═╡ 5de6f3c1-9769-44d2-aff5-c07c6144fcaa
@time println(fib(40))

# ╔═╡ 949ffbe1-17ee-4650-aa52-0b378bbafdf5
@time for _=1:4
	println(fib(40))
end

# ╔═╡ 893a5737-7239-4eeb-99ba-f1e61e4cc87b
@time Threads.@threads for _=1:4
	println(fib(40))
end

# ╔═╡ 6c049382-90a3-44c7-ba2d-d38042ede03b
md"""
### 各種API（2） `@spawn`
"""

# ╔═╡ 36833a0f-eaa7-471f-80f3-c69a1cae3d55
md"""
`Threads.nthreads()` 等略
"""

# ╔═╡ 28a3792b-9c91-445c-9364-de1b2085ff13
@time @sync for _=1:4
	Threads.@spawn println(fib(40))
end

# ╔═╡ c0db9109-78d3-4344-ba65-f4a1f7b2ff87
md"""
### 各種API（3） `@threads` v.s. `@spawn` (1)
"""

# ╔═╡ 4deba4e4-7468-4a8c-998d-ddafb6c24158
let
	hist = zeros(Int, Threads.nthreads())
	@time Threads.@threads for _=1:(10000*Threads.nthreads())
		fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
		hist[Threads.threadid()] += 1
	end
	hist
end

# ╔═╡ 51cac03d-c4e3-4c84-97b8-3ee8cba2de2d
let
	hist = zeros(Int, Threads.nthreads())
	@time @sync for _=1:(10000*Threads.nthreads())
		Threads.@spawn begin
			fib(15)  # 毎回ほぼ同じ負荷の処理が実行される例
			hist[Threads.threadid()] += 1
		end
	end
	hist
end

# ╔═╡ d437a7bd-09b9-4764-8c9c-c23a27594042
md"""
### 各種API（4） `@threads` v.s. `@spawn` (2)
"""

# ╔═╡ 1407558c-b7cd-43af-8f77-2327fd90f34e
let
	hist = zeros(Int, Threads.nthreads())
	@time Threads.@threads for _=1:(250*Threads.nthreads())
		fib(rand(25:35))  # 毎回わずかに異なる負荷の処理が実行
		hist[Threads.threadid()] += 1
	end
	hist
end

# ╔═╡ 688fe3d2-792e-4c6d-9f20-5c91b7ce24a5
let
	hist = zeros(Int, Threads.nthreads())
	@time @sync for _=1:(250*Threads.nthreads())
		Threads.@spawn begin
			fib(rand(25:35))  # 毎回わずかに異なる負荷の処理が実行
			hist[Threads.threadid()] += 1
		end
	end
	hist
end

# ╔═╡ 049994d7-7112-4fb9-b9d6-dd4295e37a9c
md"""
## 実例
"""

# ╔═╡ 42138b48-e3a6-41cf-822a-cf50c0b55efe
md"""
### 実例（1） `@threads` の例(1)
"""

# ╔═╡ 5b8d754a-b655-4560-9759-0d1798baeda9
function my_matmul(A::AbstractMatrix, B::AbstractMatrix)
	T = promote_type(eltype(A), eltype(B))
	C = Matrix{T}(undef, (size(A, 1), size(B, 2)))
	Threads.@threads for x = axes(B, 2)
		Threads.@threads for y = axes(A, 1)
			C[y, x] = @view(A[y, :])' * @view(B[:, x])
		end
	end
	C
end

# ╔═╡ e99325ae-4a5a-4e10-8695-b4fa63dc29b5
let A=[1 2; 3 4; 5 6; 7 8], B=[1 2 3; 4 5 6]
	C = my_matmul(A, B)
	@assert C == A * B
	@show C;
end

# ╔═╡ 6a99bf8d-8327-46fe-90e2-2b24dacf269c
md"""
### 実例（2） `@threads` の例(2)
"""

# ╔═╡ 74a6b87b-cb52-4e95-821c-8eb98192d968
function my_matmul_st(A::AbstractMatrix, B::AbstractMatrix)
	T = promote_type(eltype(A), eltype(B))
	C = Matrix{T}(undef, (size(A, 1), size(B, 2)))
	for x = axes(B, 2)
		for y = axes(A, 1)
			C[y, x] = @view(A[y, :])' * @view(B[:, x])
		end
	end
	C
end

# ╔═╡ 659e9e0f-7ffa-4664-b137-43cc8973a242
@btime my_matmul_st(A, B) setup=(A=rand(100, 100); B=rand(100, 100));

# ╔═╡ 1b30667b-ee64-4f43-ad7a-22b2c720c5da
@btime my_matmul(A, B) setup=(A=rand(100, 100); B=rand(100, 100));

# ╔═╡ 53b8f016-f47b-4083-96fe-3789a43cc86a
# 参考
@btime (A * B) setup=(A=rand(100, 100); B=rand(100, 100));

# ╔═╡ 660581c6-2dbb-4019-96bb-6eaca841491f
md"""
### 実例（3） `@spawn` の例
"""

# ╔═╡ 219d010c-36b4-4b77-a586-c5f42020f0b5
function threaded_map(fn, array::AbstractArray)
	tasks = [Threads.@spawn(fn(v)) for v in array]
	[fetch(task) for task in tasks]
end

# ╔═╡ 3939639a-1668-4b10-92de-edcc07d85e8a
threaded_map(fib, 15:40) == map(fib, 15:40)

# ╔═╡ 8e8e287c-d60f-4d79-9bc5-35c02c522386
@time map(fib, 15:40)

# ╔═╡ 583ec01b-9ccf-4f83-af7e-440f1d51e330
@time threaded_map(fib, 15:40)

# ╔═╡ 446c108c-cdb3-4d63-98c0-6067d6bdaf72
md"""
### 注意（1） スレッドセーフについて(1)
"""

# ╔═╡ c5907d87-e7da-4ae3-8fdd-2be48585b56d
mutable struct UnsafeCounter
	count::Int
	UnsafeCounter() = new(0)
end

# ╔═╡ 30ff3527-dfc9-469f-ac81-2907352607a6
begin
	counter1=UnsafeCounter()
	for n=1:1000
		counter1.count += 1
	end
	counter1.count
end

# ╔═╡ 5413f8e0-ab2d-4a5c-b600-648b8d9aad9b
begin
	counter2=UnsafeCounter()
	Threads.@threads for n=1:1000
		counter2.count += 1
	end
	counter2.count
end

# ╔═╡ 02572376-8518-4469-b3d2-bb01760f8eae
md"""
### 注意（2） スレッドセーフについて(2)
"""

# ╔═╡ a2661f37-8071-4fd3-a30e-8b146407b10f
mutable struct AtomicCounter
	Threads.@atomic count::Int
	AtomicCounter() = new(0)
end

# ╔═╡ 47385f8e-4d9a-4819-8ebf-831939f56fdc
begin
	counter3 = AtomicCounter()
	for n=1:1000
		Threads.@atomic counter3.count += 1
	end
	counter3.count
end

# ╔═╡ 7a02dead-3d80-4745-ae37-d470a0775abd
begin
	counter4 = AtomicCounter()
	Threads.@threads for n=1:1000
		Threads.@atomic counter4.count += 1
	end
	counter4.count
end

# ╔═╡ 33a6ecbe-0892-4bd7-9156-177951a81691
md"""
## 実習：並列化によるパフォーマンス改善
"""

# ╔═╡ dacd1e85-0f2c-4aef-a1f6-47f089c36da4
md"""
### お題：N-Queen問題(2)
"""

# ╔═╡ 5e39b554-ed6f-45fa-8314-439c1d17f785
md"""
### お題：N-Queen問題(3)
"""

# ╔═╡ c2004bca-9826-4861-867b-d6f0aa0ec3b3
function create_board(n, params)
    board = falses(n, n)
    for (x, y) in pairs(params)
        board[y, x] = true
    end
    board
end

# ╔═╡ 491346dc-769c-4d38-bbd5-7d663e2bff39
function issafe(board::BitMatrix, y, x)
    h, w = size(board)
    any(board[y, :]) && return false
    any(board[:, x]) && return false
    any(board[y-i, x-i] for i=1:min(y, x)-1) && return false
    any(board[y+i, x+i] for i=1:min(h-y, w-x)) && return false
    any(board[y-i, x+i] for i=1:min(y-1, w-x)) && return false
    any(board[y+i, x-i] for i=1:min(h-y, x-1)) && return false
    true
end

# ╔═╡ 94b34bb3-a56a-444f-80a2-a920c3cb91cd
function nQueen_sub(n::Int, k::Int, params::Vector{Int})
    k == n && return 1
    board = create_board(n, params)
    counter = AtomicCounter()
    for y=1:n
        if issafe(board, y, k + 1)
            Threads.@atomic counter.count += nQueen_sub(n, k+1, [params; y])
        end
    end
    counter.count
end

# ╔═╡ c8671277-4dcb-4a91-a9bd-a90c9bbbf620
function nQueen(n::Int)
    counter = AtomicCounter()  # 先ほど作ったカウンタを利用
    for y=1:n
        Threads.@atomic counter.count += nQueen_sub(n, 1, [y])
    end
    counter.count
end

# ╔═╡ a0eec840-b2c0-4141-bc5c-af6aca5a9cfe
md"""
### お題：N-Queen問題(4)
"""

# ╔═╡ e92cedba-b3e0-4a13-bb6d-30016dc34cda
md"""
```julia
using BenchmarkTools  # 既に実行済
```
"""

# ╔═╡ 5e441244-e44d-412f-93a1-b9e6e2b720b4
@btime nQueen(8)

# ╔═╡ 64025b39-6e94-42d6-b6e3-36c824adf96c
@btime nQueen(9)

# ╔═╡ d0e18e43-4f0d-481b-bb3d-041ec6b518a5
@btime nQueen(10)

# ╔═╡ 550c34b9-0a4d-4a9e-b43f-b7cea325796b
@btime nQueen(11)

# ╔═╡ f8f26964-9f9c-4954-90b8-f1af458ab328
md"""
### お題：N-Queen問題(5)
"""

# ╔═╡ aa956139-08be-4fcc-8617-23c026c712cd
# ↓マルチスレッド化してみよう！
# ↓適宜編集して最適な挙動にしてみよう！
function nQueen_subMT(n::Int, k::Int, params::Vector{Int})
    k == n && return 1
    board = create_board(n, params)
    counter = AtomicCounter()
    for y=1:n
        if issafe(board, y, k + 1)
            Threads.@atomic counter.count += nQueen_sub(n, k+1, [params; y])
            # Threads.@atomic counter.count += nQueen_subMT(n, k+1, [params; y])
        end
    end
    counter.count
end

# ╔═╡ 1872a6d9-39a2-40a2-b9f1-a6e180eab6c0
# ↓マルチスレッド化してみよう！
function nQueenMT(n::Int)
    counter = AtomicCounter()  # 先ほど作ったカウンタを利用
    for y=1:n
        Threads.@atomic counter.count += nQueen_subMT(n, 1, [y])
    end
    counter.count
end

# ╔═╡ 7c5ef138-9a3c-405a-8713-8f6654b6247c
md"""
### お題：N-Queen問題(6)
"""

# ╔═╡ bdd17d7a-c2de-47a3-b205-7d15ff014f75
md"""
```julia
using BenchmarkTools  # 既に実行済
```
"""

# ╔═╡ e5298178-cde9-4ed7-94b1-c14bbef33c59
@btime nQueenMT(8)

# ╔═╡ 6384cc08-27b4-4f94-ae1e-cbb799985208
@btime nQueenMT(9)

# ╔═╡ 2db9aa86-db63-40db-82f5-61072a28f322
@btime nQueenMT(10)

# ╔═╡ 16333019-f3ac-4cf4-97da-dd1e72013ceb
@btime nQueenMT(11)

# ╔═╡ d78d0515-fb07-4460-b39a-8aee305a8c66
@btime nQueen(12)

# ╔═╡ 8a802ce0-d67f-4ca9-ac73-19805fc6e8ba
@btime nQueenMT(12)

# ╔═╡ 99f2d800-b7a7-420a-9a5d-4a8d15fedea4


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"

[compat]
BenchmarkTools = "~1.3.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "8c72e043718b5b2b781afa164b5e4ec6fa6c9bde"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═81faba57-dc86-48c9-a53d-806db4a4d7cb
# ╟─c64be533-3b1a-4d7e-be35-e934ee9ee18c
# ╟─5512d5ab-d27e-48ad-8adb-6eba75efa144
# ╟─d14ab956-11d8-4811-ac52-ea4c0c53c7be
# ╟─ce550b07-87b2-464e-b483-e0651cab18c0
# ╠═10b6a16c-27c8-4881-b77f-bb57935d33c6
# ╠═bcdba047-5543-4fcf-b9cc-702dbb8241f7
# ╠═2f78aaec-0909-11ee-06c4-dfb316a8d214
# ╠═f72a18c7-378e-478c-9743-3cc61179ea5d
# ╠═5de6f3c1-9769-44d2-aff5-c07c6144fcaa
# ╠═949ffbe1-17ee-4650-aa52-0b378bbafdf5
# ╠═893a5737-7239-4eeb-99ba-f1e61e4cc87b
# ╟─6c049382-90a3-44c7-ba2d-d38042ede03b
# ╟─36833a0f-eaa7-471f-80f3-c69a1cae3d55
# ╠═28a3792b-9c91-445c-9364-de1b2085ff13
# ╟─c0db9109-78d3-4344-ba65-f4a1f7b2ff87
# ╠═4deba4e4-7468-4a8c-998d-ddafb6c24158
# ╠═51cac03d-c4e3-4c84-97b8-3ee8cba2de2d
# ╟─d437a7bd-09b9-4764-8c9c-c23a27594042
# ╠═1407558c-b7cd-43af-8f77-2327fd90f34e
# ╠═688fe3d2-792e-4c6d-9f20-5c91b7ce24a5
# ╟─049994d7-7112-4fb9-b9d6-dd4295e37a9c
# ╟─42138b48-e3a6-41cf-822a-cf50c0b55efe
# ╠═5b8d754a-b655-4560-9759-0d1798baeda9
# ╠═e99325ae-4a5a-4e10-8695-b4fa63dc29b5
# ╟─6a99bf8d-8327-46fe-90e2-2b24dacf269c
# ╠═74a6b87b-cb52-4e95-821c-8eb98192d968
# ╠═cbcd0d61-6ca8-42f5-8ec3-9d6c7efb7530
# ╠═659e9e0f-7ffa-4664-b137-43cc8973a242
# ╠═1b30667b-ee64-4f43-ad7a-22b2c720c5da
# ╠═53b8f016-f47b-4083-96fe-3789a43cc86a
# ╟─660581c6-2dbb-4019-96bb-6eaca841491f
# ╠═219d010c-36b4-4b77-a586-c5f42020f0b5
# ╠═3939639a-1668-4b10-92de-edcc07d85e8a
# ╠═8e8e287c-d60f-4d79-9bc5-35c02c522386
# ╠═583ec01b-9ccf-4f83-af7e-440f1d51e330
# ╟─446c108c-cdb3-4d63-98c0-6067d6bdaf72
# ╠═c5907d87-e7da-4ae3-8fdd-2be48585b56d
# ╠═30ff3527-dfc9-469f-ac81-2907352607a6
# ╠═5413f8e0-ab2d-4a5c-b600-648b8d9aad9b
# ╟─02572376-8518-4469-b3d2-bb01760f8eae
# ╠═a2661f37-8071-4fd3-a30e-8b146407b10f
# ╠═47385f8e-4d9a-4819-8ebf-831939f56fdc
# ╠═7a02dead-3d80-4745-ae37-d470a0775abd
# ╟─33a6ecbe-0892-4bd7-9156-177951a81691
# ╟─dacd1e85-0f2c-4aef-a1f6-47f089c36da4
# ╠═c8671277-4dcb-4a91-a9bd-a90c9bbbf620
# ╠═94b34bb3-a56a-444f-80a2-a920c3cb91cd
# ╟─5e39b554-ed6f-45fa-8314-439c1d17f785
# ╠═c2004bca-9826-4861-867b-d6f0aa0ec3b3
# ╠═491346dc-769c-4d38-bbd5-7d663e2bff39
# ╟─a0eec840-b2c0-4141-bc5c-af6aca5a9cfe
# ╟─e92cedba-b3e0-4a13-bb6d-30016dc34cda
# ╠═5e441244-e44d-412f-93a1-b9e6e2b720b4
# ╠═64025b39-6e94-42d6-b6e3-36c824adf96c
# ╠═d0e18e43-4f0d-481b-bb3d-041ec6b518a5
# ╠═550c34b9-0a4d-4a9e-b43f-b7cea325796b
# ╠═d78d0515-fb07-4460-b39a-8aee305a8c66
# ╟─f8f26964-9f9c-4954-90b8-f1af458ab328
# ╠═1872a6d9-39a2-40a2-b9f1-a6e180eab6c0
# ╠═aa956139-08be-4fcc-8617-23c026c712cd
# ╟─7c5ef138-9a3c-405a-8713-8f6654b6247c
# ╟─bdd17d7a-c2de-47a3-b205-7d15ff014f75
# ╠═e5298178-cde9-4ed7-94b1-c14bbef33c59
# ╠═6384cc08-27b4-4f94-ae1e-cbb799985208
# ╠═2db9aa86-db63-40db-82f5-61072a28f322
# ╠═16333019-f3ac-4cf4-97da-dd1e72013ceb
# ╠═8a802ce0-d67f-4ca9-ac73-19805fc6e8ba
# ╠═99f2d800-b7a7-420a-9a5d-4a8d15fedea4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
