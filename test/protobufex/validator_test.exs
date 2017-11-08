Code.require_file("../support/test_msg.ex", __DIR__)
defmodule Protobufex.ValidatorTest do
  use ExUnit.Case, async: true

  test "oneof valid for valid tuple and nil" do
    msg = TestMsg.Oneof.new(first: {:a, 42})
    assert true = Protobufex.Validator.valid?(msg)
  end

  test "oneof invalid format" do
    msg = TestMsg.Oneof.new(first: 1)
    assert {:invalid, error} = Protobufex.Validator.valid?(msg)
    assert error =~ ~r/be a tuple {:field, val}/
  end

  test "oneof field doesn't match" do
    msg = TestMsg.Oneof.new(first: {:c, 42})
    assert {:invalid, error} = Protobufex.Validator.valid?(msg)
    assert error =~ ~r/:c doesn't match oneof field :first/
  end

  test "oneof field is invalid" do
    msg = TestMsg.Oneof.new(first: {:a, "abc"})
    assert {:invalid, error} = Protobufex.Validator.valid?(msg)
    assert error =~ ~r/:a of :first is invalid/
  end
end
