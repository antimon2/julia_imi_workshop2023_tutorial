### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ d3c5cd60-1a47-11ee-01db-8371349c3c9c
versioninfo()

# ╔═╡ 44b4f59a-3025-44bc-9a26-a23c3ca07c16
md"""
# 型と多重ディスパッチ
"""

# ╔═╡ d6da3161-6ae7-4fc2-b67f-7421b7961050
md"""
## 型システムの基本
"""

# ╔═╡ c3f242d6-d22d-4e51-9a41-ea572939dcf6
md"""
### 型とは何か（1）
"""

# ╔═╡ f2b57a9d-93b7-49cd-a250-fb3773a4a52e
typeof(1)

# ╔═╡ a756bf89-c7c6-431d-b234-d2b8d8627bff
typeof("文字列")

# ╔═╡ 1eba1d36-44b3-4f51-8862-67b6858e5058
typeof([1.0, 2.0, 3.0])

# ╔═╡ 98feb651-37ff-4641-8825-b42e98380a36
md"""
### Julia の型システム（1）
"""

# ╔═╡ 58ae9e52-1da4-47d9-935a-5220f28a274a
typeof(1) === Int
# Int という型は唯一

# ╔═╡ 3b8f4580-b1e9-4d2c-9a49-010d6a6e9dd4
Int <: Signed <: Integer <: Real <: Number <: Any
# ↑ `<:` は派生型演算子（左辺が右辺の派生型なら `true`）

# ╔═╡ 77f8844b-1dc7-417c-b3b5-096f4a9a5e48
1 isa Number
# `a isa T` は `typeof(a) <: T` と（ほぼ）等価

# ╔═╡ b8f22f7e-2be0-4ba5-9039-52d51f425819
md"""
### Julia の型システム（2）
"""

# ╔═╡ d6be3c97-6e72-4546-86fa-da5b34cbb7e4
supertype(Int)

# ╔═╡ e09224fc-e1a8-4f6e-98f8-87b3765da0d0
supertype(String)

# ╔═╡ d946f1cb-f20b-4132-9a56-9b47ab18d3f5
subtypes(AbstractString)  # 環境によって結果は変る

# ╔═╡ 2e44677d-5ed5-4ccf-b81b-4f4329658d15
length(subtypes(Any))  # 環境によって結果は変る

# ╔═╡ 79780124-abaf-4eb4-8a93-4367b1382550
md"""
### Julia の型システム（3）
"""

# ╔═╡ 787c9de7-c7c8-4687-966d-48c82a251b58
md"""
![Fig4-2.svg](https://gist.github.com/antimon2/234ffd7070318518e24611b2d0b33e58/raw/28995aea2f75171870a8331c7a2bf794b8281608/Fig4-2.svg)
"""

# ╔═╡ 41f24fc9-cb2e-4f66-a953-3cc3430a3eb9
md"""
### 代表的な型の紹介（1）
"""

# ╔═╡ 711ce408-7460-41f8-9d02-1bece39748f7
typeof(4294967296)

# ╔═╡ 65bcd618-5b41-4027-a923-1a3d0ed209cb
typeof(9223372036854775808)

# ╔═╡ 94b0f38b-01ef-4ff1-8370-866c40be6259
typeof(170141183460469231731687303715884105728)

# ╔═╡ 4ce79839-1b10-4bc6-8dd8-874d4847b8ff
typeof(0x01)

# ╔═╡ ec1a9bea-2286-482b-bbb9-a47cb56cc667
typeof(0x0123456789abcdef)

# ╔═╡ b1eadc63-a8e6-4655-96ae-e7ca7a484878
md"""
### 代表的な型の紹介（2）
"""

# ╔═╡ ab764ba0-0e42-448b-a9d3-52810507b207
typeof(1.0) === typeof(0.) === typeof(-.0) === Float64
# よくある表記は大抵 Float64

# ╔═╡ 2206a919-e53b-4e8b-a8d2-eb0460385125
typeof(1e308) === typeof(0x193p-2) === Float64
# `0x《16進表記》p《2の冪数》`という書式もOK

# ╔═╡ 7fa365e2-c9db-4820-80d3-b54882dc9d73
typeof(3.14f0)
# `xxxfyy` と言う書式にすると Float32 になる

# ╔═╡ 9336f10d-8db1-4ded-bd09-432aabc47d7c
Float16(3.1416)  # Float16 は明示的に指定

# ╔═╡ c3d2d1f9-67d1-4974-a5bb-7b03e8102080
big(π)  # BigFloat の例

# ╔═╡ cbd3ab15-c0eb-41b0-9bc0-4b800c61c70a
md"""
### 代表的な型の紹介（3）
"""

# ╔═╡ feb06d63-a19a-4b2d-81db-daf636fcc8fd
typeof(1//2)

# ╔═╡ 9b909cc4-edc1-472b-8794-dd45ce185d4f
-12//20
# 結果は適宜約分される

# ╔═╡ c3113e32-a303-44ce-8b8b-561a2e8e51bf
3//0  # これもOK（`0//0` のみエラー）

# ╔═╡ e85ba801-7d07-40e7-809c-87abd7a3a1ce
im  # 虚数単位（定数として定義済）

# ╔═╡ ce42c1d8-3175-4d6a-a61a-20f4970aafc4
typeof(1 + 2im)

# ╔═╡ 04feb012-33a1-43af-a273-a303efc6de62
typeof(0.0 + 1.0im)

# ╔═╡ 4679506a-3635-45d2-b668-6b3ada2370ed
md"""
### 代表的な型の紹介（4）
"""

# ╔═╡ 08794db6-11e1-497a-abfa-9211b7d54721
typeof('a')

# ╔═╡ d00123c3-4f09-4c18-975f-9a505b15990f
typeof("a")

# ╔═╡ dcd0377e-8d3b-4ec5-9ca7-fb332ae18a73
typeof("""
	複数行にわたる文字列
	これも String 型
""")

# ╔═╡ 89c0bd66-8092-4284-a50c-c9a2b9c969a7
md"""
### 代表的な型の紹介（5）
"""

# ╔═╡ 5be47f94-3616-4980-922e-1e4a71fb1bc6
typeof([1.0, 2.0, 3.0])
# ↑リストではなくベクトル（＝1次元配列）

# ╔═╡ 03c1419b-98f6-473f-8aef-5199a9817401
typeof([
  1 2
  3 4
])  # 行列（＝2次元配列）

# ╔═╡ 6b79e759-3a0e-4bbc-bfb4-c8ca788ebd7e
typeof([1;2;;3;4;;;5;6;;7;8])
# 2×2×2 の3次元配列

# ╔═╡ e2c1b5c3-859b-496f-91c7-c4fcf2dc4253
md"""
### 代表的な型の紹介（6）
"""

# ╔═╡ 9ab7dd2b-22fa-4ee8-8c9e-af1f701e0035
Dict("Alice"=>1, "Bob"=>2, "Carol"=>3)
# 結果は順不同

# ╔═╡ a900f53c-757a-4676-b28c-1fd975de6e53
Set([3, 1, 4, 1, 5, 9, 2, 6, 5, 3])
# 重複は排除される
# こちらも順不同

# ╔═╡ e02c86cf-aa5f-4ef6-a653-b70542252a6f
md"""
### 代表的な型の紹介（7）
"""

# ╔═╡ bf16f483-28a1-43c4-8439-f7ab0a9beec5
typeof((1, 'b', "三"))

# ╔═╡ 2d724f27-c8a5-428c-9fa1-0a9e0448e154
typeof((a=1, b='b', c="三"))

# ╔═╡ cf61c8c5-4674-4cba-9f04-fa0608a2cb35
md"""
### 型アノテーション
"""

# ╔═╡ 80040126-18d0-42c1-beee-990a316515ec
let
	x::Int = sin(π)  # == 0.0 なので変換されて 0 が代入される
	x
end

# ╔═╡ bfedd14f-fb99-417c-99db-2d124d21a8c0
let
	x = (sin(π)::Int)  # こちらはエラー（!(sin(π) <: Int) なので）
	x
end

# ╔═╡ 74d6b311-c7c6-4e15-922b-fd12737f8f67
md"""
## 複合型と抽象型
"""

# ╔═╡ 679ff86d-dac9-457f-8244-780ecf4194fa
md"""
### 複合型(1) （構造体）
"""

# ╔═╡ 7199e3c2-b2b6-454d-9d23-c91f3989a11c
struct SSample
	x
	y
end

# ╔═╡ 274a63f8-203e-455e-a0ec-95e825cb109c
ssample = SSample(1, 2)

# ╔═╡ 8882e8e5-8814-4da6-8620-d753a0c15dcc
typeof(ssample)

# ╔═╡ f1a8d294-42b6-47c4-83a0-82e9144dcf80
md"""
### 複合型(2) （フィールドの型指定）
"""

# ╔═╡ 4b486604-4a45-45ab-ba38-aa85e52c9748
struct SISample
	x::Int
	y::Int
end

# ╔═╡ cd8d5eb9-5c2c-4db5-a5fb-68a251f4fd5c
sisample = SISample(1, 2)

# ╔═╡ 4be5740c-81e5-432e-b94a-f72a24dc1685
typeof(sisample.x)

# ╔═╡ 9d3248c5-d84e-4de7-977d-c69af987cd4b
SISample(2.0, 3.14)  # `3.14` の方でエラーが発生

# ╔═╡ eb314894-b8f3-4463-b31e-e01ea2a19c9e
md"""
### 複合型(3) （基本型の指定）
"""

# ╔═╡ d0768610-860f-428f-bfde-b316d4d669f8
struct MyDecimal <: Real
	value::BigInt
	point::Int
end  # 固定小数点数を意図した型定義

# ╔═╡ fb4f2f72-f691-47ea-abd2-8381eb27f04f
MyDecimal(1, 0) isa Number

# ╔═╡ 627a50ab-a4fe-436a-a2ea-3daeaf4a7c60
MyDecimal(1, 0) isa Integer

# ╔═╡ 05f03dad-83b5-42b6-8889-60b3b98a3c7f
md"""
### 抽象型(1)
"""

# ╔═╡ 80f1921f-12c4-4e56-a003-87f8b4d71bbc
abstract type AbstractFPoint end

# ╔═╡ ca88de96-086b-42d3-81f6-30e828bb1eee
struct FPoint2D <: AbstractFPoint
	x::Float64
	y::Float64
end

# ╔═╡ ff9c5420-c31c-4c62-895f-2a5b76679fef
struct FPoint3D <: AbstractFPoint
	x::Float64
	y::Float64
	z::Float64
end

# ╔═╡ f332d8e1-a51d-4905-8a18-7322eef0a881
FPoint2D(1.0, 2.0) isa AbstractFPoint

# ╔═╡ f55a171d-42f3-49ed-8959-1c702b11209e
FPoint3D(3, π, 99.9) isa AbstractFPoint

# ╔═╡ 28eeae8d-e65d-45d9-ab37-4748b5dbe43f
md"""
### 型パラメータ(1)
"""

# ╔═╡ 08d65866-d01a-4318-81f3-58452ed8c3a1
struct TWrapperSample{T}
	value::T
end

# ╔═╡ 19d6ad0b-53bc-4345-93ca-0da26c0342df
intwrapper = TWrapperSample(1)

# ╔═╡ 443971a6-abb1-4de2-8acf-2e2d1a018621
typeof(intwrapper)

# ╔═╡ 008035e4-d8b9-4a39-84a7-b26c019a2a4e
typeof(TWrapperSample("文字列"))

# ╔═╡ 83baa388-36e3-40ab-836d-f116be2c3171
md"""
### 型制約(1)
"""

# ╔═╡ f3326409-81db-44f6-ad18-45cc0ad4ec34
abstract type AbstractPoint{T <: Real} end

# ╔═╡ 33013691-582d-4fa0-8136-1a24890b9160
struct Point2D{T} <: AbstractPoint{T}
	x::T
	y::T
end

# ╔═╡ 4ec5abb0-53b3-45e8-9d77-21a7d080e671
Point2D(1.0, 3.2) isa AbstractPoint{Float64}

# ╔═╡ 2e226b04-0691-4de1-8cf3-d75bf86a477d
Point2D(1 + 0im, 0 + im)

# ╔═╡ 4e166336-2b8c-43a9-b2ae-1ff8c79ae954
md"""
## 多重ディスパッチの基本
"""

# ╔═╡ 19befd56-3891-41ed-9782-de41d3eb0c01
md"""
### 多重ディスパッチとは(1)
"""

# ╔═╡ 09ab22a8-ff7e-48aa-9626-8c26df2bf396
add(x, y) = x + y

# ╔═╡ 695daefb-8195-48a0-bfe1-61afe84c7dd3
add(x, y, z) = x + y + z

# ╔═╡ 86797d66-cfa3-46b6-bf47-debf8d070fd9
add(x, y, z...) = add(x + y, z...)

# ╔═╡ 08462eff-9758-4f87-b77f-528ab14f5cc6
methods(add)

# ╔═╡ e24fc9e5-b9e0-4b29-8bc9-cab4f79a9c20
md"""
### 多重ディスパッチとは(2)
"""

# ╔═╡ 2a421fc4-ebc9-432f-9885-91033c9ff023
double(x) = 2x

# ╔═╡ fe60b34c-71a7-4a5f-9915-150fd1532610
double(s::AbstractString) = s ^ 2

# ╔═╡ 0538e512-f336-4503-92c8-71ba33beafb8
double(x, y) = string(double(x), double(y))

# ╔═╡ 42d2caeb-09f5-4f1b-9126-22257149f4a4
double(x::Number, y::Number) = double(x) + double(y)

# ╔═╡ 0a5605a1-ad60-4865-86d4-844dcfab67db
md"""
### 多重ディスパッチとは(3)
"""

# ╔═╡ b59bc619-2372-4aef-9d77-a759a6509491
md"""
### Juliaにおける多重ディスパッチの利用例(1)
"""

# ╔═╡ b819e624-0fa1-400b-9d89-9bb42322a1d2
log(20)  # 自然対数

# ╔═╡ cb4973dd-5440-470a-946f-34a5c463ac77
log(5, 20)  # 底を5とする対数

# ╔═╡ 5322e4b3-e4c8-4cb7-a6b5-9930b2fe850c
atan(0.3)  # tan(θ) == 0.3 となる θ

# ╔═╡ 3d27c612-6592-44c5-8769-f055853865a6
atan(1, 3)  # tan(θ) == 1/3 となる θ

# ╔═╡ 0797b554-db40-499b-93f0-5f191a1e5bb9
md"""
### Juliaにおける多重ディスパッチの利用例(2)
"""

# ╔═╡ 0243457b-4010-4afa-9479-29b3fe5a76e4
1 * 2  # 整数どうしの `*` 演算は結果も整数

# ╔═╡ 7c1bf931-cca6-461f-8c2d-74f261d416d6
3.0 * π  # 浮動小数点数と無理数の `*` 演算は浮動小数点数

# ╔═╡ 5195fdfd-5477-4e97-8dc4-3ef22fe44e9d
"Hello, " * "Julia!"  # 文字列同士の `*` 演算は結合

# ╔═╡ f17bf480-c9c8-4f2e-9974-f45190771682
md"""
## 実習：Julia の多重ディスパッチと型定義
"""

# ╔═╡ 38e97304-c33c-4cd9-b181-ece6d9947386
md""" お題：`double()`関数 """

# ╔═╡ e0b20009-e64e-41f6-81e4-ca1f9757da32
md"""
### Step1: 型定義
"""

# ╔═╡ 30021c97-a8a4-49e3-a8f6-0150648d7692
struct MyType{T}
	value::T
end

# ╔═╡ 1f9a6ec2-5601-41e1-a6b3-67bc05867bda
MyType(1)

# ╔═╡ bd81398e-422a-4617-97b2-e134d19ca51f
md"""
### Step2: 関数の多重定義(1)
"""

# ╔═╡ 8fa53b88-2b59-4cd0-bc54-57a80018defc
double(mytype::MyType) = nothing  # ここを適切に実装
# そのままだとエラーになってしまうので、Pluto 上は `nothing` を返すだけの実装にしておく

# ╔═╡ 59bd3722-327c-40a8-8bc1-f9e237eae8d1
md"""
### Step3: 関数の多重定義(2)
"""

# ╔═╡ cf72b716-9f83-4ad9-b680-153b2a6bd9e2
double(x::MyType, y::MyType)= nothing  # ここを適切に実装
# そのままだとエラーになってしまうので、Pluto 上は `nothing` を返すだけの実装にしておく

# ╔═╡ 0e65d04d-a530-4f6c-8ea3-0dff21a7897e
double(x::MyType, y) = nothing  # ここを適切に実装
# そのままだとエラーになってしまうので、Pluto 上は `nothing` を返すだけの実装にしておく

# ╔═╡ 0e775625-8379-451a-87a1-54d64eb0dd52
double(x, y::MyType) = nothing  # ここを適切に実装
# そのままだとエラーになってしまうので、Pluto 上は `nothing` を返すだけの実装にしておく

# ╔═╡ ab8eefa2-d283-456a-a7d7-79e1e98db68f
methods(double)

# ╔═╡ 136f9376-fe0d-45b0-b4cc-db5f0cf7d6fe
double("文字列")
# "文字列" isa AbstractString なので s ^ 2 の実装（メソッド）が選択される

# ╔═╡ cf1a1a22-0982-4d96-adbb-0a0d3d1a2fc7
double(1, 2)
# 1 isa Number かつ 2 isa Number なので double(x) + double(y)

# ╔═╡ e9d6ed00-b852-4b91-ae1a-6784289338cc
double(160, "円")
# どうしてこうなるのか考えてみよう！

# ╔═╡ 3aab14d2-d43a-420b-8435-c8f2849745c1
double(MyType(1))  #> MyType{Int64}(2)

# ╔═╡ 2ed55087-0257-496a-ae03-41f3bfcf833d
double(MyType("ABC"))  #> MyType{String}("ABCABC")

# ╔═╡ d32a5a9c-24ee-4e58-9847-d34382378677
double(2, MyType(π))  #> MyType{Float64}(10.283185307179586)

# ╔═╡ 6c2836c0-8bb0-4032-bfd5-8ed551a3493a
double(MyType(35), "v")  #> MyType{String}("70vv")

# ╔═╡ 53eb0d06-22af-4d15-a0cd-30cd97747867
double(MyType("ABC"), MyType("XYZ"))  #> MyType{String}("ABCABCXYZXYZ")

# ╔═╡ 01c31e78-ea0d-4821-afe2-14e93d5a4688


# ╔═╡ Cell order:
# ╠═d3c5cd60-1a47-11ee-01db-8371349c3c9c
# ╟─44b4f59a-3025-44bc-9a26-a23c3ca07c16
# ╟─d6da3161-6ae7-4fc2-b67f-7421b7961050
# ╟─c3f242d6-d22d-4e51-9a41-ea572939dcf6
# ╠═f2b57a9d-93b7-49cd-a250-fb3773a4a52e
# ╠═a756bf89-c7c6-431d-b234-d2b8d8627bff
# ╠═1eba1d36-44b3-4f51-8862-67b6858e5058
# ╟─98feb651-37ff-4641-8825-b42e98380a36
# ╠═58ae9e52-1da4-47d9-935a-5220f28a274a
# ╠═3b8f4580-b1e9-4d2c-9a49-010d6a6e9dd4
# ╠═77f8844b-1dc7-417c-b3b5-096f4a9a5e48
# ╟─b8f22f7e-2be0-4ba5-9039-52d51f425819
# ╠═d6be3c97-6e72-4546-86fa-da5b34cbb7e4
# ╠═e09224fc-e1a8-4f6e-98f8-87b3765da0d0
# ╠═d946f1cb-f20b-4132-9a56-9b47ab18d3f5
# ╠═2e44677d-5ed5-4ccf-b81b-4f4329658d15
# ╟─79780124-abaf-4eb4-8a93-4367b1382550
# ╟─787c9de7-c7c8-4687-966d-48c82a251b58
# ╟─41f24fc9-cb2e-4f66-a953-3cc3430a3eb9
# ╠═711ce408-7460-41f8-9d02-1bece39748f7
# ╠═65bcd618-5b41-4027-a923-1a3d0ed209cb
# ╠═94b0f38b-01ef-4ff1-8370-866c40be6259
# ╠═4ce79839-1b10-4bc6-8dd8-874d4847b8ff
# ╠═ec1a9bea-2286-482b-bbb9-a47cb56cc667
# ╟─b1eadc63-a8e6-4655-96ae-e7ca7a484878
# ╠═ab764ba0-0e42-448b-a9d3-52810507b207
# ╠═2206a919-e53b-4e8b-a8d2-eb0460385125
# ╠═7fa365e2-c9db-4820-80d3-b54882dc9d73
# ╠═9336f10d-8db1-4ded-bd09-432aabc47d7c
# ╠═c3d2d1f9-67d1-4974-a5bb-7b03e8102080
# ╟─cbd3ab15-c0eb-41b0-9bc0-4b800c61c70a
# ╠═feb06d63-a19a-4b2d-81db-daf636fcc8fd
# ╠═9b909cc4-edc1-472b-8794-dd45ce185d4f
# ╠═c3113e32-a303-44ce-8b8b-561a2e8e51bf
# ╠═e85ba801-7d07-40e7-809c-87abd7a3a1ce
# ╠═ce42c1d8-3175-4d6a-a61a-20f4970aafc4
# ╠═04feb012-33a1-43af-a273-a303efc6de62
# ╟─4679506a-3635-45d2-b668-6b3ada2370ed
# ╠═08794db6-11e1-497a-abfa-9211b7d54721
# ╠═d00123c3-4f09-4c18-975f-9a505b15990f
# ╠═dcd0377e-8d3b-4ec5-9ca7-fb332ae18a73
# ╟─89c0bd66-8092-4284-a50c-c9a2b9c969a7
# ╠═5be47f94-3616-4980-922e-1e4a71fb1bc6
# ╠═03c1419b-98f6-473f-8aef-5199a9817401
# ╠═6b79e759-3a0e-4bbc-bfb4-c8ca788ebd7e
# ╟─e2c1b5c3-859b-496f-91c7-c4fcf2dc4253
# ╠═9ab7dd2b-22fa-4ee8-8c9e-af1f701e0035
# ╠═a900f53c-757a-4676-b28c-1fd975de6e53
# ╟─e02c86cf-aa5f-4ef6-a653-b70542252a6f
# ╠═bf16f483-28a1-43c4-8439-f7ab0a9beec5
# ╠═2d724f27-c8a5-428c-9fa1-0a9e0448e154
# ╟─cf61c8c5-4674-4cba-9f04-fa0608a2cb35
# ╠═80040126-18d0-42c1-beee-990a316515ec
# ╠═bfedd14f-fb99-417c-99db-2d124d21a8c0
# ╟─74d6b311-c7c6-4e15-922b-fd12737f8f67
# ╟─679ff86d-dac9-457f-8244-780ecf4194fa
# ╠═7199e3c2-b2b6-454d-9d23-c91f3989a11c
# ╠═274a63f8-203e-455e-a0ec-95e825cb109c
# ╠═8882e8e5-8814-4da6-8620-d753a0c15dcc
# ╟─f1a8d294-42b6-47c4-83a0-82e9144dcf80
# ╠═4b486604-4a45-45ab-ba38-aa85e52c9748
# ╠═cd8d5eb9-5c2c-4db5-a5fb-68a251f4fd5c
# ╠═4be5740c-81e5-432e-b94a-f72a24dc1685
# ╠═9d3248c5-d84e-4de7-977d-c69af987cd4b
# ╟─eb314894-b8f3-4463-b31e-e01ea2a19c9e
# ╠═d0768610-860f-428f-bfde-b316d4d669f8
# ╠═fb4f2f72-f691-47ea-abd2-8381eb27f04f
# ╠═627a50ab-a4fe-436a-a2ea-3daeaf4a7c60
# ╟─05f03dad-83b5-42b6-8889-60b3b98a3c7f
# ╠═80f1921f-12c4-4e56-a003-87f8b4d71bbc
# ╠═ca88de96-086b-42d3-81f6-30e828bb1eee
# ╠═ff9c5420-c31c-4c62-895f-2a5b76679fef
# ╠═f332d8e1-a51d-4905-8a18-7322eef0a881
# ╠═f55a171d-42f3-49ed-8959-1c702b11209e
# ╟─28eeae8d-e65d-45d9-ab37-4748b5dbe43f
# ╠═08d65866-d01a-4318-81f3-58452ed8c3a1
# ╠═19d6ad0b-53bc-4345-93ca-0da26c0342df
# ╠═443971a6-abb1-4de2-8acf-2e2d1a018621
# ╠═008035e4-d8b9-4a39-84a7-b26c019a2a4e
# ╟─83baa388-36e3-40ab-836d-f116be2c3171
# ╠═f3326409-81db-44f6-ad18-45cc0ad4ec34
# ╠═33013691-582d-4fa0-8136-1a24890b9160
# ╠═4ec5abb0-53b3-45e8-9d77-21a7d080e671
# ╠═2e226b04-0691-4de1-8cf3-d75bf86a477d
# ╟─4e166336-2b8c-43a9-b2ae-1ff8c79ae954
# ╟─19befd56-3891-41ed-9782-de41d3eb0c01
# ╠═09ab22a8-ff7e-48aa-9626-8c26df2bf396
# ╠═695daefb-8195-48a0-bfe1-61afe84c7dd3
# ╠═86797d66-cfa3-46b6-bf47-debf8d070fd9
# ╠═08462eff-9758-4f87-b77f-528ab14f5cc6
# ╟─e24fc9e5-b9e0-4b29-8bc9-cab4f79a9c20
# ╠═2a421fc4-ebc9-432f-9885-91033c9ff023
# ╠═fe60b34c-71a7-4a5f-9915-150fd1532610
# ╠═0538e512-f336-4503-92c8-71ba33beafb8
# ╠═42d2caeb-09f5-4f1b-9126-22257149f4a4
# ╠═ab8eefa2-d283-456a-a7d7-79e1e98db68f
# ╟─0a5605a1-ad60-4865-86d4-844dcfab67db
# ╠═136f9376-fe0d-45b0-b4cc-db5f0cf7d6fe
# ╠═cf1a1a22-0982-4d96-adbb-0a0d3d1a2fc7
# ╠═e9d6ed00-b852-4b91-ae1a-6784289338cc
# ╟─b59bc619-2372-4aef-9d77-a759a6509491
# ╠═b819e624-0fa1-400b-9d89-9bb42322a1d2
# ╠═cb4973dd-5440-470a-946f-34a5c463ac77
# ╠═5322e4b3-e4c8-4cb7-a6b5-9930b2fe850c
# ╠═3d27c612-6592-44c5-8769-f055853865a6
# ╟─0797b554-db40-499b-93f0-5f191a1e5bb9
# ╠═0243457b-4010-4afa-9479-29b3fe5a76e4
# ╠═7c1bf931-cca6-461f-8c2d-74f261d416d6
# ╠═5195fdfd-5477-4e97-8dc4-3ef22fe44e9d
# ╟─f17bf480-c9c8-4f2e-9974-f45190771682
# ╟─38e97304-c33c-4cd9-b181-ece6d9947386
# ╟─e0b20009-e64e-41f6-81e4-ca1f9757da32
# ╠═30021c97-a8a4-49e3-a8f6-0150648d7692
# ╠═1f9a6ec2-5601-41e1-a6b3-67bc05867bda
# ╟─bd81398e-422a-4617-97b2-e134d19ca51f
# ╠═8fa53b88-2b59-4cd0-bc54-57a80018defc
# ╠═3aab14d2-d43a-420b-8435-c8f2849745c1
# ╠═2ed55087-0257-496a-ae03-41f3bfcf833d
# ╟─59bd3722-327c-40a8-8bc1-f9e237eae8d1
# ╠═cf72b716-9f83-4ad9-b680-153b2a6bd9e2
# ╠═0e65d04d-a530-4f6c-8ea3-0dff21a7897e
# ╠═0e775625-8379-451a-87a1-54d64eb0dd52
# ╠═d32a5a9c-24ee-4e58-9847-d34382378677
# ╠═6c2836c0-8bb0-4032-bfd5-8ed551a3493a
# ╠═53eb0d06-22af-4d15-a0cd-30cd97747867
# ╠═01c31e78-ea0d-4821-afe2-14e93d5a4688
