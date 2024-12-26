#!/bin/bash
# func/nextjs.sh

deploy_nextjs() {
	domain=$1
	user=$2
	app_name=$3

	# Validate input
	check_args '3' "$#" 'DOMAIN USER APP_NAME'
	is_object_valid 'user' 'USER' "$user"
	is_object_valid 'web' 'DOMAIN' "$domain"

	app_dir="/home/$user/web/$domain/public_html"
	pm2_config="$app_dir/ecosystem.config.js"

	# Switch to target user
	su - $user -c "
        cd $app_dir
        npm install
        npm run build

        # Create PM2 config
        cat > $pm2_config <<EOL
module.exports = {
  apps: [{
    name: '$app_name',
    script: 'node_modules/next/dist/bin/next',
    args: 'start',
    env: {
      NODE_ENV: 'production',
    }
  }]
}
EOL

        # Start/Restart PM2
        pm2 restart $app_name || pm2 start $pm2_config
        pm2 save
    "
}
