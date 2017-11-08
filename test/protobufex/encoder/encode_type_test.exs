defmodule Protobufex.Encoder.DecodeTypeTest do
  use ExUnit.Case, async: true

  alias Protobufex.Encoder

  test "encode_type/2 varint" do
    assert Encoder.encode_type(:int32, 42) == <<42>>
  end

  test "encode_type/2 min int32" do
    assert Encoder.encode_type(:int32, -2147483648) == <<128, 128, 128, 128, 248, 255, 255, 255, 255, 1>>
  end

  test "encode_type/2 min int64" do
    assert Encoder.encode_type(:int64, -9223372036854775808) == <<128, 128, 128, 128, 128, 128, 128, 128, 128, 1>>
  end

  test "encode_type/3 min sint32" do
    assert Encoder.encode_type(:sint32, -2147483648) ==<<255, 255, 255, 255, 15>>
  end

  test "encode_type/3 max sint32" do
    assert Encoder.encode_type(:sint32, 2147483647) == <<254, 255, 255, 255, 15>>
  end

  test "encode_type/3 min sint64" do
    assert Encoder.encode_type(:sint64, -9223372036854775808) == <<255, 255, 255, 255, 255, 255, 255, 255, 255, 1>>
  end

  test "encode_type/3 max sint64" do
    assert Encoder.encode_type(:sint64, 9223372036854775807)== <<254, 255, 255, 255, 255, 255, 255, 255, 255, 1>>
  end

  test "encode_type/3 bool false" do
    assert Encoder.encode_type(:bool, false) == <<0>>
  end

  test "encode_type/3 bool true" do
    assert Encoder.encode_type(:bool, true) == <<1>>
  end

  test "encode_type/3 a fixed64" do
    assert Encoder.encode_type(:fixed64, 8446744073709551615) == <<255, 255, 23, 118, 251, 220, 56, 117>>
  end

  test "encode_type/3 max fixed64" do
    assert Encoder.encode_type(:fixed64, 18446744073709551615) == <<255, 255, 255, 255, 255, 255, 255, 255>>
  end

  test "encode_type/3 min sfixed64" do
    assert Encoder.encode_type(:sfixed64, -9223372036854775808) == <<0, 0, 0, 0, 0, 0, 0, 128>>
  end

  test "encode_type/3 max sfixed64" do
    assert Encoder.encode_type(:sfixed64, 9223372036854775807) == <<255, 255, 255, 255, 255, 255, 255, 127>>
  end

  test "encode_type/3 min double" do
    assert Encoder.encode_type(:double, 5.0e-324) == <<1, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "encode_type/3 max double" do
    assert Encoder.encode_type(:double, 1.7976931348623157e308) == <<255, 255, 255, 255, 255, 255, 239, 127>>
  end

  test "encode_type/3 string" do
    assert Encoder.encode_type(:string, "testing") == <<7, 116, 101, 115, 116, 105, 110, 103>>
  end

  test "encode_type/3 bytes" do
    assert Encoder.encode_type(:bytes, <<42, 43, 44, 45>>) == <<4, 42, 43, 44, 45>>
  end

  test "encode_type/3 fixed32" do
    assert Encoder.encode_type(:fixed32, 4294967295) == <<255, 255, 255, 255>>
  end

  test "encode_type/3 sfixed32" do
    assert Encoder.encode_type(:sfixed32, 2147483647) == <<255, 255, 255, 127>>
  end

  test "encode_type/3 float" do
    assert Encoder.encode_type(:float, 3.4028234663852886e38) == <<255, 255, 127, 127>>
  end
end
