# pubsub.rb - code for pubsub

require 'wisper'

##
# pubsub - publish and subscribe
#
# Glossary:
# Event : - triggers a state transition
# Action : - What a publisher fires in respond to event listener
# FSA : - Finite State Automaton - Handles event state transitions
# Publisher : - Certain things that publish actions
# Subscriber : - Things that listen for Actions from Publishers.
# 
# Work in conjunction with micromachine
# 
# When an event trigger happens, the listener block fires.
# This listener (for the state,transition pair would make a call to some publisher
# The subscribers to the published action would fire their listeners.
#
# Consider the state of some editor world
# A Buffer has text and a cursor position after some part of the tet
# User presses  the Backspace key
# This causes the :del_back event to fire
# The event listener fires for this event
# This causes a BufferModifier to transmit the :del_back Action.
# The Buffer is listening for this Action
# The UserNotifier is listening for this Action
# The KeyLogger is listening for this Action
#
# Interactions with Vish controller code
#
# 
# These subscribers should just collect symbols and return in the tuple
# return from listen(key)
# [:state, [:del_back, :speak_delete, :key_log_del_back]]
# This maps to an object:
# ~{del_back: ->() { xmit(buffer(), del_back:) },
#    speak_delete: ->() { print("delete :{ch}") },



