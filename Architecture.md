# buffer Architecture
## Abstract

Uses:

- micromachine - FSM for states: modes
- wisper - PubSub for responding to state changes
- Vish code to compose larger things together
## Prototype Vish code

```
# What we want to do in a loop:
defn Main() {
  get_key() | transit() | publish() | logit() | consume()
}
#
loop {
  continue?=Main()
  continue? && break
}
```


In the Main() fn above, we 

1. Wait for a key - Will return a symbol :key_D
2. Will run the FSM through 1 state transition
3. Publish this event to all subscribers
  3.a Each subscriber transmit a single message - A symbol or Callable object
  3.b. These are collected into a tuple
4. Log the messages transmitted
5. Consume all messages.

These message consumers are Vish lambdas in a  a object:

```
# consume a tupple of messages in any order
defn consume(msgs) {
  each(msgs, ->(m) {
    %object[:m]
  })
}
```

An example object:

```
object=World() {
  ~{
    next_buf: ->() { next() },
    search_fwd: ->() { }, # nop - mode was changed in FSM
    word_back: ->() { word_back() },
 ...
  }
}
```


Each action above probably converts into Viper API attached call: 'next()'





## Logging

The logit() method is another PubSubber. 

Each message is filtered by a presence or abscence of a consumer.

- subscriber A - the current Buffer in the foreground that is R/W
  * Action logging for Undo/Redo
* Macro logging for undo of playback.
    - For macro recording
- Subscriber B - The search history. Suitable for reload for this project later.
- Subscriber C - The project state recorder - Current state of open buffers
- Subscriber D -  Observer for current buffer that tracks mark location

Note in the later case:

The current mark (topmark in mark ring) is a tuple of or pair of line, column
There is a predicate if the cursor is agead or at or beind the current mark.
If behind, deletions or insertions may change the value of this Pair.

This is the observer pattern.

All code modifier functions functions should output the count of characters (and
lines?) A negative number if if deletions.
This can be merged with mark to change its location.




## Transit - State transitions

### Error handling

If a transition does not exist for a given state, this FSM returns false.
Then the symbol :error is sent to the pubsubber.

Consider the following interaction.

Alt-D key
State change to delete-mode
key_i entered
FSM outputs :error
The delete mode is subscribing to this event
Outputs the Action :key_not_supported_in_delete_node
In consumer, action fires: print('Key is not supported in delete mode"); print("Press ? to see a list of available keys and their actions")

Note: Still in delete-mode.

Next valid key outputs its stuff :delete_clear_line  ... .etc
And FSM returns to idle state
