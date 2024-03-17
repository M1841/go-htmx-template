package main

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"go-htmx-template/pkg/utils"
	"os"
)

type App struct {
	Env          string
	Count        int
	ResetVisible bool
}

func newApp(e string) App {
	return App{
		Env:          e,
		Count:        0,
		ResetVisible: false,
	}
}

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Renderer = utils.NewTemplate()

	e.Static("/styles", "./web/styles")
	e.Static("/public", "./web/public")
	e.Static("/scripts", "./web/scripts")

	app := newApp(os.Getenv("APP_ENV"))

	e.GET("/", func(c echo.Context) error {
		return c.Render(200, "index", app)
	})

	e.POST("/count", func(c echo.Context) error {
		if !app.ResetVisible {
			app.ResetVisible = true
		}
		app.Count++

		return c.Render(200, "buttons", app)
	})

	e.DELETE("/count", func(c echo.Context) error {
		app.Count = 0
		app.ResetVisible = false

		return c.Render(200, "buttons", app)
	})

	port, isSet := os.LookupEnv("PORT")
	if !isSet {
		port = "8080"
	}

	e.Logger.Fatal(e.Start(":" + port))
}
