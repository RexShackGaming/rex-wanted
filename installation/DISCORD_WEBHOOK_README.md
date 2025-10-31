# Discord Webhook System

## Overview
This wanted system now includes Discord webhook integration to log important events directly to your Discord server.

## Setup Instructions

### 1. Create a Discord Webhook
1. Go to your Discord server
2. Navigate to Server Settings → Integrations → Webhooks
3. Click "New Webhook" or "Create Webhook"
4. Configure the webhook:
   - Set a name (e.g., "Wanted System")
   - Choose the channel where logs should be posted
   - Copy the webhook URL
5. Click "Save"

### 2. Configure the Script
1. Open `config.lua`
2. Locate the Discord configuration section:
   ```lua
   Config.Discord = {
       Enabled = true,
       WebhookURL = '', -- Add your webhook URL here
       BotName = 'Wanted System',
       BotAvatar = 'https://i.imgur.com/placeholder.png',
       Color = 16711680,
       
       LogOutlawStatus = true,
       LogStatusCleared = true,
       LogThresholdReached = true,
   }
   ```
3. Paste your webhook URL into the `WebhookURL` field
4. Customize other settings as needed:
   - `Enabled`: Enable/disable webhook logging
   - `BotName`: Display name for webhook messages
   - `BotAvatar`: Avatar image URL for the webhook bot
   - `Color`: Default embed color (decimal format)

### 3. Customize Event Logging
Toggle which events are logged to Discord:
- `LogOutlawStatus`: Log when a player's wanted status changes
- `LogStatusCleared`: Log when wanted status is cleared
- `LogThresholdReached`: Log when outlaw trigger amount is reached

## Features

### Logged Events

#### 1. Wanted Status Update 🚨
Logged when a player's wanted level changes:
- Player name
- Citizen ID
- Wanted level
- Player identifier
- Optional reason
- Color: Red (if >= OutlawTriggerAmount) or Yellow

#### 2. Wanted Status Cleared ✅
Logged when a player's wanted status is cleared:
- Player name
- Citizen ID
- Player identifier
- Color: Green

### Using the Update Event
Trigger wanted status changes from other scripts:
```lua
-- Example: Update a player's wanted level
TriggerEvent('rex-wanted:server:updateOutlawStatus', 25, 'Killed a lawman')

-- Example: Clear wanted level
TriggerEvent('rex-wanted:server:updateOutlawStatus', 0, 'Paid bounty')
```

## Embed Colors
Colors are in decimal format. Common colors:
- Red: `16711680`
- Green: `65280`
- Blue: `255`
- Yellow: `16776960`
- Orange: `16744192`
- Purple: `8388736`

Convert hex colors to decimal: `0xFF0000` → `16711680`

## Troubleshooting

### Webhooks not sending
1. Verify your webhook URL is correct
2. Ensure `Config.Discord.Enabled = true`
3. Check that the webhook hasn't been deleted from Discord
4. Verify the channel still exists
5. Check server console for errors

### Partial information in logs
- Ensure RSGCore is properly initialized
- Check database connection
- Verify player data is being fetched correctly

## Security Notes
- Keep your webhook URL private
- Do not commit webhook URLs to public repositories
- Rotate webhooks if accidentally exposed
- Limit webhook channel permissions to staff only

## Support
For issues or questions, refer to the main script documentation or contact the script developer.
