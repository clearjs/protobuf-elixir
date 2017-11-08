defmodule Protobufex.Protoc.GeneratorTest do
  use ExUnit.Case, async: true

  alias Protobufex.Protoc.{Generator, Context}

  test "generate/2 works" do
    ctx = %Context{}
    desc = Google.Protobuf.FileDescriptorProto.new(name: "name.proto")
    assert Generator.generate(ctx, desc) == Google.Protobuf.Compiler.CodeGeneratorResponse.File.new(name: "name.pb.ex", content: "")
  end

  test "get_dep_pkgs/2 sort pkgs by length" do
    ctx = %Context{pkg_mapping: %{"foo.proto" => "foo", "foo_bar.proto" => "foo.bar"}}
    assert Generator.get_dep_pkgs(ctx, ["foo.proto", "foo_bar.proto"]) == ["foo.bar", "foo"]
  end
end
