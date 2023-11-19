# Build the application from source
FROM golang:1.20 AS build-stage

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o ./server


# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage
ARG PORT=8082
ENV PORT=${PORT}
WORKDIR /app

COPY --from=build-stage /app/server /app/server

EXPOSE ${PORT}


ENTRYPOINT ["/app/server"]