defmodule Protobufex.Protoc.Generator.EnumTest do
  use ExUnit.Case, async: true

  alias Protobufex.Protoc.Context
  alias Protobufex.Protoc.Generator.Enum, as: Generator

  test "generate/2 generates enum type messages" do
    ctx = %Context{package: ""}
    desc = %Google.Protobuf.EnumDescriptorProto{name: "EnumFoo",
      options: nil,
      value: [%Google.Protobuf.EnumValueDescriptorProto{name: "A", number: 0},
              %Google.Protobuf.EnumValueDescriptorProto{name: "B", number: 1}]
    }
    msg = Generator.generate(ctx, desc)
    assert msg =~ "defmodule EnumFoo do\n"
    assert msg =~ "use Protobufex, enum: true\n"
    refute msg =~ "defstruct "
    assert msg =~ "field :A, 0\n  field :B, 1\n"
  end
end