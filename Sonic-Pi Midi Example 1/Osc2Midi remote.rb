midi_all_notes_off
live_loop "osc2midi" do
  use_real_time
  n,v,d,ch = sync "/osc:*:4560/midi"
  midi n,v,sustain: d,channel: ch,port: "midi_through_port-0"
end