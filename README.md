# NGINX snippets

Some building blocks and structure for Nginx config to change the Nginx server
file from this

```
server {
	listen 80;
	listen [::]:80;
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
	include /etc/letsencrypt/options-ssl-nginx.conf;
	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

	access_log /var/log/nginx/redirected.access;
	error_log /var/log/nginx/redirected.error;

	server_name
		example.com
		sub.example.com
		sub3.example.com;

	return 301 https://www.$host$request_uri;
}
```

to this

```
server {
	include snippets/listen/all.conf;
	include snippets/ssl.conf;
	include snippets/log-redirect.conf;

	server_name
		example.com
		sub.example.com
		sub3.example.com;

	return 301 https://www.$host$request_uri;
}
```

It gets very easy to comprehend what's going on in the config once you get
used to ignore `include snippets/` and just read what it says. Especially
useful when setting up many vhosts.

The snippets are in the snippets dir. Usage examples in sites-available dir.

## Notes, conventions, tips

All junk that you don't use like `koi-win` or `uwsgi_params` can be removed.
I usually only have this in the nginx root:
```
$ ls /etc/nginx
conf.d/  modules@  modules-enabled/  nginx.conf  sites-available/  sites-enabled/  snippets/
```

Note that some of the *snippets*  like `mime.types`, `proxy_params` and the
fastcgi conf are not there either. This config template places them within
appropriate directories.

Anything general like *ssl* or *gzip* config should go into `conf.d`. Anything
includable should go into snippets.
