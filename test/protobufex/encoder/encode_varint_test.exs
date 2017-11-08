defmodule Protobufex.Encoder.DecodeVarintTest do
  use ExUnit.Case, async: true

  alias Protobufex.Encoder

  test "encode_varint 300" do
    assert Encoder.encode_varint(300) == <<0b1010110000000010::16>>
  end

  test "encode_varint 150" do
    assert Encoder.encode_varint(150) == <<150, 1>>
  end

  test "encode_varint 0" do
    assert Encoder.encode_varint(0) == <<0>>
  end

  test "encode_varint/2 min int32" do
    assert Encoder.encode_varint(-2147483648) == <<128, 128, 128, 128, 248, 255, 255, 255, 255, 1>>
  end

  test "encode_varint max int32" do
    assert Encoder.encode_varint(2147483647) == <<255, 255, 255, 255, 7>>
  end

  test "encode_varint/2 min int64" do
    assert Encoder.encode_varint(-9223372036854775808) == <<128, 128, 128, 128, 128, 128, 128, 128, 128, 1>>
  end

  test "encode_varint max int64" do
    assert Encoder.encode_varint(9223372036854775807) == <<255, 255, 255, 255, 255, 255, 255, 255, 127>>
  end

  test "encode_varint max uint32" do
    assert Encoder.encode_varint(4294967295) == <<255, 255, 255, 255, 15>>
  end

  test "encode_varint max uint64" do
    assert Encoder.encode_varint(18446744073709551615) == <<255, 255, 255, 255, 255, 255, 255, 255, 255, 1>>
  end
end
