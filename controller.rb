require 'artoo'
require 'vlc-client'


=begin
class Controller
end
=end

# vlc --extraintf rc --rc-host 127.0.0.1:9999

vlc = VLC::Client.new('127.0.0.1', 9999)
vlc.connect

connection :joystick, :adaptor => :joystick
device :controller, :driver => :xbox360, :connection => :joystick, :interval => 0.1

work do
  on controller, :button_a => proc { |*value|
                 if vlc.playing?
                   vlc.pause
                 else
                   vlc.play
                 end
               }
  on controller, :button_b => proc { |*value|
                 vlc.fullscreen
               }
  on controller, :button_x => proc { |*value|
                 puts vlc.title
               }
  on controller, :button_y => proc { |*value|
                 vlc.seek(50)
               }
  on controller, :joystick_0 => proc { |k, v|
       time = vlc.time
       if v[:x] > 0
         vlc.seek(time+5)
       elsif v[:x] < 0
         vlc.seek(time-5)
       end
               }
  on controller, :joystick_1 => proc { |k,v|
       volume = vlc.volume
       if v[:y] < 0
         vlc.volume = volume + 5
       elsif v[:y] > 0
         vlc.volume = volume - 5
       end
               }
  on controller, :trigger_lt => proc { |*value|
       puts value[1]
               }
  on controller, :button_lb => proc { |*value|
               vlc.previous
               }
  on controller, :button_rb => proc { |*value|
                 vlc.next
               }
  #on controller, :joystick => proc { |k,v|
  #     puts k,v
  #             }
end