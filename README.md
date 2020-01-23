# Bowling REST-API

[![Build](https://github.com/vtm9/bowling/workflows/Build/badge.svg)](https://github.com/vtm9/bowling/actions)
[![codecov](https://codecov.io/gh/vtm9/bowling/branch/master/graph/badge.svg)](https://codecov.io/gh/vtm9/bowling)

## Documentation

### Start a new bowling game

```bash
 curl -X POST  https://bowling.gigalixirapp.com/api/v1/games \
-H "Content-Type: application/json" \
-d '{"game":{"players":[{"name": "asdf"},{"name": "fdsa"}]}}'

# response
{
  "id": 1,
  "result": [
    {
      "frames": [],
      "player_name": "asdf",
      "total": 0
    },
    {
      "frames": [],
      "player_name": "fdsa",
      "total": 0
    }
  ]
}
```

### Input the number of pins knocked down by ball

```bash
curl -X POST  https://bowling.gigalixirapp.com/api/v1/games/1/balls \
-H "Content-Type: application/json" \
-d '{"ball":{"score":10}}'

# response
{}
```

### Get the current game score

```bash
curl -X GET  https://bowling.gigalixirapp.com/api/v1/games/1/balls \
-H "Content-Type: application/json"

# response
{
  "id": 1,
  "result": [
    {
      "frames": [
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 }, { "score": 10 }, { "score": 10 } ], "result": 30 }
      ],
      "player_name": "asdf",
      "total": 300
    },
    {
      "frames": [
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 } ], "result": 30 },
        { "balls": [ { "score": 10 }, { "score": 10 }, { "score": 10 } ], "result": 30 }
      ],
      "player_name": "fdsa",
      "total": 300
    }
  ]
}
```
