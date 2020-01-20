# NGINX-snippets

Some building blocks for Nginx configurations to change the Nginx vhost file from this

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
	# listen for :80 as well to avoid separate 80->443 redirect
	include snippets/listen/all;
	include snippets/ssl;
	include snippets/log.redirect;

	server_name 
		example.com
		sub.example.com
		sub3.example.com;

	return 301 https://www.$host$request_uri;
}
```

It gets very easy to comprehend what's going on in the config once you get used to ignore `include snippets/` and just read what it says. Expecially useful when setting up many vhosts.

The snippets are in the snippets dir. Usage examples in sites-available dir.

## Notes

One should use this just as a starting point and an idea on how to organize the config, it's not a complete solution for your case.

- `snippets/ssl` assumes a Let's Encrypt certificate.
- `snippets/php/fastcgi.conf` is Nginx's default `snippets/fastcgi.conf`, this repo is not an advice on how to set up FastCGI.
