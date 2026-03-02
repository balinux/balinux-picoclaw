# Social Media Downloader Skill

This skill provides functionality to download and send videos from Instagram, YouTube, TikTok, and Twitter/X directly to chat. Handles Instagram's anti-bot protection automatically.

## Commands

- `/download [url]` - Download and send video from any supported platform
- `/ig [url]` - Download and send Instagram content (when possible)
- `/yt [url]` - Download and send YouTube content
- `/tiktok [url]` - Download and send TikTok content
- `/twitter [url]` - Download and send Twitter/X content

## Features

- Supports YouTube Shorts, regular YouTube videos, Instagram posts/reels/stories, TikTok videos, Twitter/X videos
- Automatic format selection for optimal quality
- Instagram protection handling
- Direct upload to Telegram
- Auto-delete after successful upload
- Temporary file cleanup
- Environment variable support for Telegram token (TELEGRAM_BOT_TOKEN)
- Multi-channel delivery support (results sent back to source chat - group or private)
- Debug logging to track chat context

## Technical Details

The skill uses:
- `yt-dlp` for content extraction
- Custom scripts for platform-specific handling
- Telegram Bot API for direct uploads
- Automatic file cleanup after upload
- Priority order for token: Environment variable TELEGRAM_BOT_TOKEN > Config file token
- Chat context preservation to send results back to originating chat

## Files

- `social_media_downloader.sh` - Main orchestrator script with multi-channel support
- `download_video_fixed.sh` - Video download handler
- `upload_telegram.sh` - Telegram uploader with auto-delete
- `cleanup_downloads.sh` - Cleanup utility