FROM golang:1.22 as go-build-stage

WORKDIR /

COPY go.mod go.sum ./
RUN go mod download

COPY ./cmd ./cmd
COPY ./pkg ./pkg

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o ./target/release/myapp cmd/myapp/main.go

FROM node:21 as node-build-stage

WORKDIR /

COPY --from=go-build-stage ./target/release/myapp ./target/release/myapp
COPY ./web ./web

RUN cd ./web && npm i && npx tailwindcss -i ./styles/tailwind_input.css -o ./styles/tailwind_output.css

FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=node-build-stage ./target/release/myapp ./target/release/myapp
COPY --from=node-build-stage ./web ./web

ENV APP_ENV=prod

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["./target/release/myapp"]