defmodule Protobufex.Protoc.Generator.ServiceTest do
  use ExUnit.Case, async: true

  alias Protobufex.Protoc.Context
  alias Protobufex.Protoc.Generator.Service, as: Generator

  test "generate/2 generates services" do
    ctx = %Context{package: "foo"}
    desc = %Google.Protobuf.ServiceDescriptorProto{name: "ServiceFoo",
      method: [
        %Google.Protobuf.MethodDescriptorProto{name: "MethodA", input_type: "Input0", output_type: "Output0"},
        %Google.Protobuf.MethodDescriptorProto{name: "MethodB", input_type: "Input1", output_type: "Output1", client_streaming: true},
        %Google.Protobuf.MethodDescriptorProto{name: "MethodC", input_type: "Input2", output_type: "Output2", server_streaming: true},
        %Google.Protobuf.MethodDescriptorProto{name: "MethodD", input_type: "Input3", output_type: "Output3", client_streaming: true, server_streaming: true},
        %Google.Protobuf.MethodDescriptorProto{
          name: "MethodE", input_type: "Input0", output_type: "Output0", options: Map.put(%Google.Protobuf.MethodOptions{},
            :http, %{
              pattern: {"post", "/v1/api"}
            }
          )
        }
      ]
    }
    msg = Generator.generate(ctx, desc)
    assert msg =~ "defmodule Foo.ServiceFoo do\n"
    assert msg =~ "use Protobufex.Service\n"
    assert msg =~ "rpc :MethodA, Foo.Input0, Foo.Output0\n"
    assert msg =~ "rpc :MethodB, stream(Foo.Input1), Foo.Output1\n"
    assert msg =~ "rpc :MethodC, Foo.Input2, stream(Foo.Output2)\n"
    assert msg =~ "rpc :MethodD, stream(Foo.Input3), stream(Foo.Output3)\n"
    assert msg =~ "rpc :MethodE, Foo.Input0, Foo.Output0, post: \"/v1/api\"\n"
  end
end
