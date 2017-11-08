defmodule Protobufex.Decoder.DecodeTypeTest do
  use ExUnit.Case, async: true
  import Bitwise, only: [band: 2]

  alias Protobufex.Decoder

  test "decode_type/2 varint" do
    {t, rest} = Decoder.decode_varint(<<8, 42, 34, 3, 97, 98, 99>>)
    t = band(t, 7)
    {_, rest2} = Decoder.decode_type(t, rest)
    assert rest2 == <<34, 3, 97, 98, 99>>
  end

  test "decode_type/2 64bits" do
    {t, rest} = Decoder.decode_varint(<<9, 0, 0, 0, 0, 0, 0, 69, 64, 34, 3, 97, 98, 99>>)
    t = band(t, 7)
    {_, rest2} = Decoder.decode_type(t, rest)
    assert rest2 == <<34, 3, 97, 98, 99>>
  end

  test "decode_type/2 string" do
    {t, rest} = Decoder.decode_varint(<<10, 1, 97, 34, 3, 97, 98, 99>>)
    t = band(t, 7)
    {_, rest2} = Decoder.decode_type(t, rest)
    assert rest2 == <<34, 3, 97, 98, 99>>
  end

  test "decode_type/2 32bits" do
    {t, rest} = Decoder.decode_varint(<<13, 0, 0, 40, 66, 34, 3, 97, 98, 99>>)
    t = band(t, 7)
    {_, rest2} = Decoder.decode_type(t, rest)
    assert rest2 == <<34, 3, 97, 98, 99>>
  end

  test "decode_type/3 min sint32" do
    {t, rest} = Decoder.decode_varint(<<8, 255, 255, 255, 255, 15>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sint32, t, rest)
    assert n == -2147483648
  end

  test "decode_type/3 max sint32" do
    {t, rest} = Decoder.decode_varint(<<8, 254, 255, 255, 255, 15>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sint32, t, rest)
    assert n == 2147483647
  end

  test "decode_type/3 min sint64" do
    {t, rest} = Decoder.decode_varint(<<8, 255, 255, 255, 255, 255, 255, 255, 255, 255, 1>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sint64, t, rest)
    assert n == -9223372036854775808
  end

  test "decode_type/3 max sint64" do
    {t, rest} = Decoder.decode_varint(<<8, 254, 255, 255, 255, 255, 255, 255, 255, 255, 1>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sint64, t, rest)
    assert n == 9223372036854775807
  end

  test "decode_type/3 bool false" do
    {t, rest} = Decoder.decode_varint(<<8>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:bool, t, rest)
    refute n
  end

  test "decode_type/3 bool true" do
    {t, rest} = Decoder.decode_varint(<<8, 1>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:bool, t, rest)
    assert n
  end

  test "decode_type/3 a fixed64" do
    {t, rest} = Decoder.decode_varint(<<9, 255, 255, 23, 118, 251, 220, 56, 117>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:fixed64, t, rest)
    assert n == 8446744073709551615
  end

  test "decode_type/3 max fixed64" do
    {t, rest} = Decoder.decode_varint(<<9, 255, 255, 255, 255, 255, 255, 255, 255>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:fixed64, t, rest)
    assert n == 18446744073709551615
  end

  test "decode_type/3 min sfixed64" do
    {t, rest} = Decoder.decode_varint(<<9, 0, 0, 0, 0, 0, 0, 0, 128>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sfixed64, t, rest)
    assert n == -9223372036854775808
  end

  test "decode_type/3 max sfixed64" do
    {t, rest} = Decoder.decode_varint(<<9, 255, 255, 255, 255, 255, 255, 255, 127>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sfixed64, t, rest)
    assert n == 9223372036854775807
  end

  test "decode_type/3 min double" do
    {t, rest} = Decoder.decode_varint(<<9, 1, 0, 0, 0, 0, 0, 0, 0>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:double, t, rest)
    assert n == 5.0e-324
  end

  test "decode_type/3 max double" do
    {t, rest} = Decoder.decode_varint(<<9, 255, 255, 255, 255, 255, 255, 239, 127>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:double, t, rest)
    assert n == 1.7976931348623157e308
  end

  test "decode_type/3 string" do
    {t, rest} = Decoder.decode_varint(<<10, 7, 116, 101, 115, 116, 105, 110, 103>>)
    t = band(t, 7)
    {str, _} = Decoder.decode_type(:string, t, rest)
    assert str == "testing"
  end

  test "decode_type/3 bytes" do
    {t, rest} = Decoder.decode_varint(<<10, 4, 42, 43, 44, 45>>)
    t = band(t, 7)
    {bytes, _} = Decoder.decode_type(:bytes, t, rest)
    assert bytes == <<42, 43, 44, 45>>
  end

  test "decode_type/3 fixed32" do
    {t, rest} = Decoder.decode_varint(<<13, 255, 255, 255, 255>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:fixed32, t, rest)
    assert n == 4294967295
  end

  test "decode_type/3 sfixed32" do
    {t, rest} = Decoder.decode_varint(<<13, 255, 255, 255, 127>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:sfixed32, t, rest)
    assert n == 2147483647
  end

  test "decode_type/3 float" do
    {t, rest} = Decoder.decode_varint(<<13, 255, 255, 127, 127>>)
    t = band(t, 7)
    {n, _} = Decoder.decode_type(:float, t, rest)
    assert n == 3.4028234663852886e38
  end
end
