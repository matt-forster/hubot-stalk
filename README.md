# hubot-stalk

#### Hubot knows what your team is doing.

Set your status for the rest of your team to see.
Can report on the last 3 status' set and when the last one was set.

**Purpose**: To make up for the lack of user status' in slack.

Features planned:

* List the current status' of everybody registered (or X most recent people)
* Hubot listens to a user set list of commands and records them, can then report on the last 5
* users can set a team for themselves and then list the status' of people in a specific team

See [`src/stalk.coffee`](src/stalk.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-stalk --save`

Then add **hubot-stalk** to your `external-scripts.json`:

```json
["hubot-stalk"]
```

## Sample Interaction

```
matt  >> hubot status out to lunch
hubot >> matt: I set your status to: out to lunch
matt  >> hubot upto chris
hubot >> chris: in the meeting
```
