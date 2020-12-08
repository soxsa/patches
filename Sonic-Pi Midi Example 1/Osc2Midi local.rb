#Osc2Midi V2

midi_all_notes_off

#Local Sync Pulse
live_loop :osc2midi_localsync do
  use_real_time
  n,v,d,ch = sync "/osc:127.0.0.1:4560/sync"
  midi n, v, channel: ch, sustain: d, port: "loopmidi_port"
end

#Volca
live_loop :osc2midi_volca do
  use_real_time
  n,v,d,ch = sync "/osc:127.0.0.1:4560/midi"
  midi n, v, channel: ch, sustain: d, port: "usb_midi_interface"
end