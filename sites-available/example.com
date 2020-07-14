# Generic PHP site with a single entry point (index.php)
server {
	include snippets/listen/443;
	include snippets/ssl;

	server_name www.example.com;

	access_log /var/log/nginx/example.com.access;
	error_log /var/log/nginx/example.com.error;

	# Prefer /srv for what the server serves
	root /srv/example.com;

	index index.php;

	try_files $uri $uri/ /index.php?$query_string;

	include snippets/php/7.4;
	include snippets/hide/htaccess;
	include snippets/hide/git;
	include snippets/phpmyadmin;
}
