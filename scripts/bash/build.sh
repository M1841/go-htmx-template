cd ./web/ || exit
pnpm i
pnpm dlx tailwindcss -i ./styles/tailwind_input.css -o ./styles/tailwind_output.css

cd ../
go build -ldflags "-s -w" -o ./target/release/myapp cmd/myapp/main.go