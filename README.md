Pavlov is a BDD framework made to look pretty sweet when using [LiveScript](https://github.com/gkz/LiveScript).

```coffeescript
describe "Livewire" do
	"Its router"():
		topic: livewire!
		"is an http.Server"(): it instanceof http.Server
		"has some sugar methods": (topic)-> <[ANY GET POST PUT DELETE OPTIONS TRACE CONNECT HEAD]> |> all (in keys topic)
		"which return the router"():
			it is it.GET "/",(->)
.run!
```

![screenshot](https://raw.github.com/quarterto/Pavlov/master/screenshot.png)

Tests are run synchronously using [node-sync](https://github.com/0ctave/node-sync), so you can spin of all the fibers you want.

Released under the terms of the [MIT License](Pavlov/LICENCE.md)