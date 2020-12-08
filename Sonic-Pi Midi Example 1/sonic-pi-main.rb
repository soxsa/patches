#Hetrogenomics

use_bpm 120

roots = [:G4, :G4, :G4, :G4,
         :G4, :G4, :G4, :G4,
         :D4, :D4, :D4, :D4].ring

#play :e5, amp: 0.2

live_loop :ext1 do
  sync :ext1
  
  notes = scale get[:extroot]-12, :blues_minor, num_octaves: 2
  #Send OSC, or midi to remote synth
  #use_osc "192.168.1.64", 4561
  #use_osc "192.168.1.3", 4560
  #use_osc "192.168.1.255", 4560
  #use_osc "127.0.0.1", 4560
  use_osc "192.168.1.81", 4560
  
  in_thread do
    8.times do
      n=notes["04005432".ring[look].to_i]
      osc "/midi",n,127,0.1,1 if ("xxxxxxxx".ring[tick]=="x") ^ one_in(0)
      sleep 0.5
    end
  end
  
  in_thread do
    12.times do
      osc "/midi", notes["34262847".ring[look].to_i],127,0.2,2 if ("x-x-x-xxx".ring[tick]=="x") ^ one_in(0)
      sleep 1.0/3
    end
  end
  
  in_thread do
    4.times do
      #osc "/midi", notes["0000".ring[look].to_i],127,0.5,3 if ("-x--".ring[tick]=="x") ^ one_in(0)
      sleep 1
    end
  end
  sleep 4
end


live_loop :ext2 do
  sync :ext2
  
  notes = scale get[:extroot]-12, :blues_minor, num_octaves: 2
  #Send OSC, or midi to remote synth
  use_osc "192.168.1.81", 4560
  use_osc "127.0.0.1", 4560
  in_thread do
    8.times do
      osc "/midi", notes["839348343".ring[look].to_i],127,0.2,1 if ("x-xxxxxxxx".ring[tick]=="x")
      sleep 1.0/4
    end
  end
  sleep 4
end

live_loop :sync do
  sync :bar4
  time_warp 4-rt(0.07) do
    use_osc "127.0.0.1", 4560
    osc "/sync",49,127,0.1,16
  end
end

live_loop :main do
  
  root = roots.tick(:root)
  
  time_warp 3-rt(0.13) do
    set :extroot, root
    sleep 1
    cue :ext1
  end
  
  time_warp 3-rt(0.00) do
    set :extroot, root
    sleep 1
    cue :ext2
  end
  
  time_warp 4.0-1.0/32 do
    set :root, root
  end
  
  sleep 4
  cue :bar
  cue :bar2 if tick%2==0
  cue :bar4 if look%4==0
  set :n, look
  
end

live_loop :arp1 do
  sync :bar
  notes = scale get[:root], :blues_minor, num_octaves: 2
  notes = [get[:root]].ring
  with_fx :echo, mix: 0.4, phase: 0.75, decay: 16 do
    8.times do
      play notes.tick, release: 0.2, amp: 0.5 if ("x-x-xxxxx".ring[tick(:a)]=="x") ^ one_in(32)
      sleep 1.0/2
    end
  end
end


live_loop :drums do
  sync :bar
  n = tick(:bar)
  s = [:bd_tek, :sn_dub, :elec_cymbal, :mehackit_robot3, :elec_filt_snare, :elec_bong, :elec_blup]
  with_fx :echo, mix: 0.2, phase: 0.75 do
    in_thread do
      16.times do
        tick
        #sample s[6], amp: 0.4 if ("-x-x-x--x---x-x-"[look]=="x") ^ one_in(8)
        #sample s[5], amp: 0.5 if ("-----x--x---x-x-"[look]=="x") ^ one_in(8)
        #sample s[4], amp: 0.9 if ("--x-x-------x---"[look]=="x") and n%4==0
        #sample s[3], amp: 1.8 if ("---x------------"[look]=="x") and n%2==0
        #sample s[2], amp: 0.2 if ("--x---x---x---x-"[look]=="x") or one_in(3)
        sample s[1], amp: 0.7 if ("----x-------x---"[look]=="x") or one_in(0)
        sample s[0], amp: 0.6 if ("x-------x-------"[look]=="x") or one_in(0)
        sleep 1.0/4
      end
    end
  end
end



