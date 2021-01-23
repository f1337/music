# Send My Love by Adele, written by Adele Adkins, Max Martin, Shellback
# Sonic Pi code by Michael R. Fleet (github.com/f1337)
# This code is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
# To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.

my_samples = "~/Downloads/"

use_bpm 81
use_debug false

######################
##| METRONOME
######################

live_loop :metronome do
  sleep 1
end


######################
##| LOOPS
######################

live_loop :drums, sync: :metronome do
  use_sample_defaults amp: 1.0
  kick_rhythm :bd_fat
end

live_loop :guitar, sync: :metronome do
  use_synth :pluck
  use_synth_defaults amp: 0.2, attack: 0, release: 0.2, pan: -0.25
  
  with_fx :reverb do
    guitar_arpeggio
  end
  
  # wait for a full run through guitar loop before chorus kicks in
  cue :chorus
end

live_loop :melody1, sync: :chorus do
  use_synth :beep
  use_synth_defaults attack: 0, release: 0.2
  
  with_fx :reverb do
    melody
  end
end

live_loop :melody2, sync: :chorus do
  use_synth :blade
  use_synth_defaults attack: 0, release: 0.85, amp: 0.2, vibrato_depth: 0.05
  
  with_fx :panslicer, phase: 8, wave: 3, invert_wave: 1 do
    melody
  end
end

live_loop :background_vocals, sync: :chorus do
  use_synth :pretty_bell
  use_synth_defaults amp: 0.05
  
  sleep 8
  
  3.times do
    if_youre_ready
  end
  
  i_am_ready
end

live_loop :snaps, sync: :chorus do
  sleep 1
  sample :perc_snap, pan: -1, amp: 0.2
  sample :perc_snap2, pan: 1, amp: 0.2
  sleep 1
end

live_loop :tambourine, sync: :chorus do
  sample my_samples, :tambourine, amp: 0.2, pan: 0.25
  sleep 0.25
end

######################
##| FUNCTIONS
######################


define :guitar_arpeggio do
  4.times do
    play_pattern_timed [:D3, :D4], [0.75, 0.5]
    # muted string:
    play_pattern_timed [:D3], [0.25], release: 0.05, sustain: 0.0
    play_pattern_timed [:D3, :A2], [0.25, 0.25]
  end
  4.times do
    play_pattern_timed [:B2, :B3], [0.75, 0.5]
    # muted string:
    play_pattern_timed [:B2], [0.25], release: 0.05, sustain: 0.0
    play_pattern_timed [:B2, :A2], [0.25, 0.25]
  end
end

define :if_youre_ready do
  sleep 0.5
  play_pattern_timed (ring :A5), [0.25], pan: 1
  play_pattern_timed (ring :A5), [0.25], pan: -1
  play_pattern_timed (ring :A5), [0.5], pan: 1
  play_pattern_timed (ring :D5), [0.5], pan: -1
end

define :i_am_ready do
  sleep 0.5
  play_pattern_timed (ring :A5), [0.25], pan: 1
  play_pattern_timed (ring :A5), [0.25], pan: -1
  play_pattern_timed (ring :A5), [0.5], pan: 1
  play_pattern_timed (ring :B5), [0.5], pan: -1
end

define :kick_rhythm do |drum|
  sample drum
  sleep 0.75
  sample drum
  sleep 0.25
  sample drum
  sleep 0.5
  sample drum
  sleep 0.75
  sample drum
  sleep 0.25
  sample drum
  sleep 0.5
  sample drum
  sleep 0.75
  sample drum
  sleep 0.25
end

define :melody do
  # variables 
  d3_maj = chord(:D3, :major)
  
  send_my_love_to_your_new = d3_maj.take(2).stretch(3)
  lover = [:D4, :D4, :A3]
  treat_her_better = [:A3, :FS3, :B3, :A3, :G3, :FS3]
  gotta_let_go = d3_maj.take(2).stretch(2)
  of_all_of_our_ghosts = [:D3] + gotta_let_go + [:E3]
  we_both_know_we_aint = (ring :D3).stretch(5)
  kids_no_more = [:D3, :FS3, :FS3, :E3, :D3]
  
  play_pattern_timed send_my_love_to_your_new, [0.25, 0.25, 0.5]
  play_pattern_timed lover, [0.5, 0.5, 2.0]
  play_pattern_timed treat_her_better, [0.5, 0.5, 0.5, 0.25, 0.25, 1.0]
  play_pattern_timed gotta_let_go, [0.25, 0.25, 0.5, 0.75]
  play_pattern_timed of_all_of_our_ghosts, [0.25, 0.25, 0.25, 0.5, 0.5, 0.75]
  play_pattern_timed we_both_know_we_aint, [0.25, 0.5, 0.25, 0.25, 0.5]
  play_pattern_timed kids_no_more, [0.5, 0.5, 0.5, 0.25, 0.25]
end
