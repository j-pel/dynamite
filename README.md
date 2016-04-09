# Dynamite (web framework)

Lightweight web framework on top of Cowboy: a dynamite powered Cowboy

This is a responsive and lightweight web framework written in Elixir that run on top of the [Cowboy web server](http://ninenines.eu/docs/en/cowboy/HEAD/guide/introduction/)

The scope of this project is to offer a dynamic environment with simple but powerful and up-to-date tools where several sites could be hosted at the same time, sharing resources when needed but with a safe and clear separation of scopes.

It is known to work well with:
* Elixir > 1.1.0
* Cowboy > 1.0.0

## Disclaimer:

The current implementation is to be taken as a proof of concept. The author is using it as a vehicle for learning Elixir. For any serious job, please consider more mature frameworks such as Phoenix.

However, given that is so simple yet well featured, flexible and performant, it could be useful for some use cases. The author have several instances running smoothly on production environments 24/7 in both Linux and Windows.

## Instructions:

With Erlang/Elixir installed, clone the repo and run within the cloned directory:

 ```
    mix deps.get
    mix deps.compile
    iex -S mix
 ```

Then, open a browser to localhost:8080. There is a sample site configured to serve static and dynamic content, including broadcasting through websockets.

Several sites could be configured to work at the same time and from different locations. It is possible to change the content of the site dynamically without ever stopping the server.

It is very easy to setup a working site on Dynamite. Each site is composed by:

* Routes: one or more Cowboy routing as EEx dynamic files 
* Views: dynamic HTML with EEx parsing
* Static: browser side functionality and static resources

The routes and views are parsed at runtime and served dynamically, so they could be modified at any time, thus facilitating the development of web applications.

In order to have a performant web application, the programmer should find a good balance between server side and browser side functionality. For example, one method to optimize the flow of data is to use a front end datastore with sync capabilities to the back end database. The browser should handle all the user interaction, formatting, data sanitization and layout (bells and whistles) while the server should handle the data retrieval and storage.

There is a sample site included in the repository that used [Pouchdb](https://pouchdb.com/api.html) as a front end for [Couchdb](http://couchdb.apache.org/) for all the data handling. The sample site includes several javascript libraries for enhancing the browser functionality:

* [Momentjs](http://momentjs.com/docs)
* [Chartjs](http://nnnick.github.io/Chart.js/docs-v2/) 
* [Dynamize](http://j-pel.github.io/dynamize)

## Mode of employ

For real life scenarios, a site should run on port 80 (or 443). It is strongly suggested to run the server without using `sudo`, for example, it is possible to use authbind and launch Dynamite as follows:
 ```
# sudo apt-get install authbind
# sudo touch /etc/authbind/byport/80
# sudo chown user /etc/authbind/byport/80
# sudo chmod 755 /etc/authbind/byport/80
# cd /home/user/path/to/dynamite
# authbind --deep mix run --name web@example.com --no-halt > test/service.log 2>&1 < /dev/null &
``` 
The last command launches an instance of a beam virtual machine, redirecting stdout to a log file.

To start Dynamite on an `iex` console, binding to port 80 without root priviledges use:.
```
# authbind --deep iex -S mix
``` 

## License:

This code is released under the MIT license.  See LICENSE.
