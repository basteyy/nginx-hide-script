# Nginx Hide Snippet Inserter 
A simple Bash script to automatically insert a specific snippet into all `server` blocks within your active Nginx configuration files.
## Description 
This script checks each `server` block in the Nginx configuration files located in `/etc/nginx/sites-enabled`. It verifies whether the following snippet is included within each `server` block:

```Code kopieren
include /etc/nginx/snippets/hide.conf;
```
 
- **If the snippet is not included** , the script will insert it right after the `server {` line.
 
- **By default** , the script will add the snippet to **only one**  `server` block per execution.
 
- Use the `--all` parameter to process all configurations and add the snippet wherever it's missing.

## Usage 

### 1. Save the Script 
Save the script as `add_hide_snippet_per_server.sh`.
### 2. Make the Script Executable 


```Code kopieren
sudo chmod +x add_hide_snippet_per_server.sh
```

### 3. Run the Script 
 
- To process configurations and add the snippet to **one**  `server` block per execution:

```Code kopieren
sudo ./add_hide_snippet_per_server.sh
```
 
- To process **all**  configurations and add the snippet wherever it's missing:

```Code kopieren
sudo ./add_hide_snippet_per_server.sh --all
```
**Note:**  `sudo` is required because the script modifies system configuration files.
### 4. Check Nginx Configuration 

After running the script, verify that the Nginx configuration is valid:


```bash
sudo nginx -t
```

If the test is successful, reload Nginx to apply the changes:


```bash
sudo systemctl reload nginx
```

## Important Notes 
 
- **Backup Before Changes** 
It is highly recommended to back up your Nginx configuration files before running the script:


```bash
sudo cp -r /etc/nginx/sites-enabled /etc/nginx/sites-enabled-backup
```
 
- **Script Assumptions**  
  - The script assumes that `server` blocks are properly formatted and that opening and closing braces `{` and `}` are matched.
 
  - If your configuration files include `server` blocks in included files or have complex nesting, the script may not work as expected.
 
- **Adjust Indentation** 
The script uses four spaces for indentation when inserting the snippet. Adjust the number of spaces if your configurations use a different indentation style.

## License 

This project is licensed under the MIT License.

## Disclaimer 

Use this script at your own risk. Always ensure you have backups and have tested configurations before applying changes to a production environment.
