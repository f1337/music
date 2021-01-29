# Send My Love by Adele, written by Adele Adkins, Max Martin, Shellback
# SonicPi (sonic-pi.net) Code by Michael R. Fleet (github.com/f1337)
# This code is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by-sa/4.0/.

my_samples = "~/Downloads/"

use_bpm 81
use_debug false

######################
##| STRUCTURE
######################

intro
2.times { verse }
pre_chorus
2.times { chorus }

guitar(:guitar_arpeggio1) # short break after first chorus

2.times { verse }
pre_chorus # TODO: end w/ drums + guitar hard 1-2 beat stop, while vox continue
2.times { chorus }

coda # TODO: ending w/ we both know we aint kids no more
bridge
2.times { chorus }

2.times do
  in_thread { coda }
  chorus
end

######################
##| PARTS
######################


define :intro do
  in_thread { 4.times { drums } }
  guitar
end

define :verse do
  in_thread { guitar }
  in_thread { 4.times { drums } }
  verse_melody
end

define :pre_chorus do
  in_thread { guitar }
  in_thread { 4.times { drums } }

  in_thread do
    with_fx :reverb do
      pre_chorus_melody :beep, { attack: 0, release: 0.2, amp: 0.5 }
    end
  end

  with_fx :reverb do
    pre_chorus_melody :dark_ambience, { attack: 0, release: 0.2, amp: 0.8 }
  end
end

# => chorus missing: rhythm guitar strum, bass
define :chorus do
  in_thread { guitar }
  in_thread { 4.times { drums } }
  in_thread { chorus_drums }

  in_thread do
    with_fx :reverb do
      chorus_melody :beep, { attack: 0, release: 0.2, amp: 0.5, pan: 0.6 }
    end
  end

  in_thread do
    with_fx :reverb do
      chorus_melody :dpulse, { attack: 0, release: 0.2, amp: 0.5, pan: -0.6 }
    end
  end

  with_fx :reverb do
    chorus_melody :dark_ambience, { amp: 0.8 }
  end
end

define :coda do
  in_thread { guitar }
  in_thread { 4.times { drums } }
  2.times { if_youre_ready }
end

define :bridge do
  in_thread { 2.times { guitar } }
  sleep 16
  pre_chorus_melody :beep, { attack: 0, release: 0.2, amp: 0.5 } # TODO: end w/ hard stop, 1-2 beat silence
end


######################
##| FUNCTIONS
######################

define :chorus_melody do |synth, synth_defaults|
  use_synth synth
  use_synth_defaults synth_defaults

  # variables
  d3_maj = chord(:D4, :major)

  send_my_love_to_your_new = d3_maj.take(2).stretch(3)
  lover = [:D5, :D5, :A4]
  treat_her_better = [:A4, :FS4, :B4, :A4, :G4, :FS4]
  gotta_let_go = d3_maj.take(2).stretch(2)
  of_all_of_our_ghosts = [:D4] + gotta_let_go + [:E4]
  we_both_know_we_aint = (ring :D4).stretch(5)
  kids_no_more = [:D4, :FS4, :FS4, :E4, :D4]

  play_pattern_timed send_my_love_to_your_new, [0.25, 0.25, 0.5]
  play_pattern_timed lover, [0.5, 0.5, 2.0]
  play_pattern_timed treat_her_better, [0.5, 0.5, 0.5, 0.25, 0.25, 1.0]
  play_pattern_timed gotta_let_go, [0.25, 0.25, 0.5, 0.75]
  play_pattern_timed of_all_of_our_ghosts, [0.25, 0.25, 0.25, 0.5, 0.5, 0.75]
  play_pattern_timed we_both_know_we_aint, [0.25, 0.5, 0.25, 0.25, 0.5]
  play_pattern_timed kids_no_more, [0.5, 0.5, 0.5, 0.25, 0.25]
end

define :drums do
  use_sample_defaults amp: 1.0
  kick_rhythm :bd_fat
end

define :chorus_drums do
  use_sample_defaults amp: 0.2

  in_thread do
    64.times do
      sample :drum_cymbal_closed
      sleep 0.25
    end

  end

  in_thread do
    sleep 7

    3.times do
      sample my_samples, :tambourine, amp: 0.8, pan: 0.25
      sleep 0.5
    end

    sleep 6.5

    3.times do
      sample my_samples, :tambourine, amp: 0.8, pan: 0.25
      sleep 0.5
    end
  end

  2.times do
    3.times do
      sleep 1
      sample :drum_snare_hard
      sample :perc_snap, pan: -1, amp: 0.1
      sample :perc_snap2, pan: 1, amp: 0.1
      sleep 1
    end

    sleep 1
    sample :drum_snare_hard
    sample :perc_snap, pan: -1, amp: 0.1
    sample :perc_snap2, pan: 1, amp: 0.1
    sleep 0.5
    sample :drum_snare_hard
    sample :perc_snap, pan: -1, amp: 0.1
    sample :perc_snap2, pan: 1, amp: 0.1
    sleep 0.25
    sample :drum_cymbal_open, finish: 0.125
    sleep 0.25
  end
end


define :guitar do |*patterns|
  use_synth :pluck

  patterns = [:guitar_arpeggio1, :guitar_arpeggio2] if patterns.empty?

  in_thread do
    use_synth_defaults amp: 0.5, attack: 0, release: 0.2, pan: -0.6
    with_fx :reverb do
      patterns.each { |pattern| send(pattern) }
    end
  end

  use_synth_defaults amp: 0.6, attack: 0, release: 0.2, pan: 0.6
  with_fx :octaver do
    patterns.each { |pattern| send(pattern) }
  end
end

define :guitar_arpeggio1 do
  4.times do
    play_pattern_timed [:D3, :D4], [0.75, 0.5]
    # muted string:
    play_pattern_timed [:D3], [0.25], release: 0.05, sustain: 0.0
    play_pattern_timed [:D3, :A2], [0.25, 0.25]
  end
end

define :guitar_arpeggio2 do
  4.times do
    play_pattern_timed [:B2, :B3], [0.75, 0.5]
    # muted string:
    play_pattern_timed [:B2], [0.25], release: 0.05, sustain: 0.0
    play_pattern_timed [:B2, :A2], [0.25, 0.25]
  end
end

define :if_youre_ready do
  3.times do
    in_thread do
      with_fx :reverb do
        if_youre_ready_arpeggio :pretty_bell, { amp: 0.2 }
      end
    end

    with_fx :reverb do
      if_youre_ready_arpeggio :hollow, { amp: 0.6 }
    end
  end

  in_thread do
    with_fx :reverb do
      i_am_ready_arpeggio :pretty_bell, { amp: 0.2 }
    end
  end

  with_fx :reverb do
    i_am_ready_arpeggio :hollow, { amp: 0.6 }
  end
end

define :if_youre_ready_arpeggio do |synth, synth_defaults|
  use_synth synth
  use_synth_defaults synth_defaults

  sleep 0.5
  play_pattern_timed (ring :A5), [0.25], pan: 1
  play_pattern_timed (ring :A5), [0.25], pan: -1
  play_pattern_timed (ring :A5), [0.5], pan: 1
  play_pattern_timed (ring :D5), [0.5], pan: -1
end

define :i_am_ready_arpeggio do |synth, synth_defaults|
  use_synth synth
  use_synth_defaults synth_defaults

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

define :pre_chorus_melody do |synth, synth_defaults|
  use_synth synth
  use_synth_defaults synth_defaults

  sleep 0.5
  play_pattern_timed [:Fs4, :E4, :E4, :A4, :Fs4], [1.5, 0.5, 0.25, 0.75, 1.0]
  play_pattern_timed [:Fs4, :E4, :E4, :E4, :A4, :Fs4], [1.0, 0.5, 0.5, 0.25, 0.75, 1.0]
  sleep 1.0
  play_pattern_timed [:Fs4, :E4, :Fs4, :B3, :D4, :E4, :Fs4], [0.5, 0.75, 0.75, 1.5, 1.0, 1.0, 1.0]
end

define :verse_melody do
  use_synth :beep
  use_synth_defaults attack: 0, release: 0.2, amp: 0.5

  sleep 0.5
  play_pattern_timed [:D4, :D4, :D4, :B3], [0.25, 0.25, 0.5, 0.75]
  sleep 0.25
  play_pattern_timed [:D4, :D4, :D4, :B3], [0.25, 0.25, 0.5, 0.75]
  play_pattern_timed [:B3, :D4, :D4, :D4, :E4], [0.25, 0.5, 0.5, 0.25, 0.75]
  play_pattern_timed [:D4, :D4, :D4, :B3], [0.25, 0.25, 0.5, 0.25]
  play_pattern_timed [:D4, :E4, :Fs4, :E4, :D4, :B3], [0.25, 0.25, 0.25, 0.25, 0.25, 0.75]
  sleep 2.25
  play_pattern_timed [:E4, :Fs4, :E4, :D4, :B3], [0.25, 0.25, 0.25, 0.25, 0.75]
  sleep 0.25
  play_pattern_timed [:Fs4, :Fs4, :E4, :Fs4, :A4, :Fs4], [0.25, 0.25, 0.25, 0.25, 0.5, 0.5]
end
