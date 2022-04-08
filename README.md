# Glup :: Quendl
This is the backend APi for quendl.

> ## 🙇‍♂️ Up && Running
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### 👨‍🎓 Sign Up

Use a POST request to `http://localhost:4000/signup` with following request body.
```
  {"username": "sample user", "password": "sample pwd"}
```

this returns `200 OK` with following body.
```
  {
    "attribute": "",
    "data": {},
    "status_code": "SUCCESS"
  }
```

### 🧙 Login

Use a POST request to `http://localhost:4000/login` with following request body.
```
{"username": "sample user", "password": "sample pwd"}
```
this returns `200 OK`  with the following body.

```
  {
    "attribute": "",
    "data": {
        "jwt": "eyJhbGc ... .ey......RigVdGWQCMu ....",
        "username": "testinguser"
    },
    "status_code": "SUCCESS"
}
```

### 🧤 test

Use a GET request to `http://localhost:4000/test` with the following request header. 
```
  {"Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTY0NzM5ODgwMSwiaWF0IjoxNjQ3Mzk1MjAxLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJyZWJpZDg0ZDU0NzZsMzA2NDAwMDBwNCIsIm5iZiI6MTY0NzM5NTIwMSwidXNlcm5hbWUiOiJoYXNpdGhhIn0.RigVdGWQCMuhh9moEG9PYcH4C0thJe7m7SLnyrOZUeg"}
```
If it is a valid token, this returns `200 OK` with following message in the body: 
```
"<Test> Success. Authenticated"
```
If the token is invalid, it returns `401` status with following response body.

```
  {
    "attribute": "",
    "data": {},
    "status_code": "UNAUTHORIZED"
  }
```