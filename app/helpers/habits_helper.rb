module HabitsHelper

  def decimalToHexString(i)

    case i
    when 0..15
      "00000" + i.to_s(16)
    when 16..255
      "0000" + i.to_s(16)
    when 256..4095
      "000" + i.to_s(16)
    when 4096..65535
      "00" + i.to_s(16)
    else
      i.to_s(16)
    end
    
  end

end
