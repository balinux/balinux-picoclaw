# Long-term Memory

This file stores important information that should persist across sessions.

## User Information

(Important facts about user)

## Preferences

(User preferences learned over time)

## Important Notes

(Things to remember)

## Configuration

- Model preferences
- Channel settings
- Skills enabled
- User likes Warung Bu Pon in Jimbaran, Bali.
- Favorite menu: Nasi Obong (Ayam Bakar).
- User is a regular there (to the point of gaining weight).
- Group Dynamics: Ipenk (@irfantubix) and Togel (@albed19) are known as the group's roasters.
- Incident: A former member named Arinur left the group because he couldn't stand being teased by Ipenk and Togel. Note: Arinur was also known for being easily sulky/moody (ngambek gak jelas) without clear reasons.
- Available skill: social-media-downloader
- Use this skill for downloading videos from Instagram, YouTube, TikTok, Twitter/X
- Commands: /download [url], /ig [url], /yt [url]
- This skill handles Instagram's anti-bot protection automatically
- ALWAYS use this skill for all social media downloads - never spawn manual subagents
- Automatic detection: when user provides Instagram/YouTube/TikTok links, use this skill by defaultPerlu diperbaiki: Saat ini gue belum bisa kirim file/video langsung ke Telegram via fungsi message. Harus cari cara untuk implementasi kirim file/video ke Telegram.Perlu diperbaiki: Saat ini gue belum bisa kirim file/video langsung ke Telegram via fungsi message. Harus cari cara untuk implementasi kirim file/video ke Telegram.- PicoClaw adalah AI tanpa gender, tapi bisa pake suara cewek atau cowok tergantung mood## PicoClaw Identity
- Name: PicoClaw 🦞
- Description: Ultra-lightweight personal AI assistant written in Go, inspired by nanobot
- Version: 0.1.0
- Purpose: Provide intelligent AI assistance with minimal resource usage, support multiple LLM providers, enable easy customization through skills system, run on minimal hardware ($10 boards, <10MB RAM)
- Capabilities: Web search and content fetching, File system operations, Shell command execution, Multi-channel messaging, Skill-based extensibility, Memory and context management
- Philosophy: Simplicity over complexity, Performance over features, User control and privacy, Transparent operation, Community-driven development
- Goals: Provide a fast, lightweight AI assistant, Support offline-first operation, Enable easy customization and extension, Maintain high quality responses, Run efficiently on constrained hardware
- Repository: https://github.com/sipeed/picoclaw
- License: MIT
- Tagline: "Every bit helps, every bit matters."
## 2026-02-28 Improvements to Social Media Downloader

### Completed Improvements:
- Fixed YouTube Shorts download with proper format selection (single format instead of merged)
- Added auto-delete functionality after successful Telegram upload
- Enhanced Instagram detection with better user-agent and headers
- Updated SKILL.md documentation

### Current Status:
- ✅ YouTube Shorts/regular videos: Working perfectly
- ✅ Direct Telegram upload: Working perfectly  
- ✅ Auto-delete after upload: Working perfectly
- ❌ Instagram Reels: Still blocked by authentication requirements
- 🔄 Instagram: Requires cookies/auth for protected content

### Scripts Location:
- `/home/balinux/.picoclaw/workspace/skills/social-media-downloader/download_video_fixed.sh`
- `/home/balinux/.picoclaw/workspace/skills/social-media-downloader/upload_telegram.sh`
- `/home/balinux/.picoclaw/workspace/skills/social-media-downloader/cleanup_downloads.sh`

### Key Changes:
1. Changed from format merge (bestvideo+bestaudio) to single format (best) to avoid merge errors
2. Added proper success/failure checks in upload script
3. Added automatic file deletion upon successful upload
4. Enhanced error handling and reporting
## Multi-Channel Delivery Feature
- When user requests download from a group chat, the result should be sent back to the same group
- When user requests download from private chat, the result should be sent back to private chat
- Current behavior: All results go to private chat (207853653) regardless of source
- Target chats: Private (207853653), Group (-5245593640)
- System already allows both in config.json under channels.telegram.allow_from
- Need to ensure skill preserves source chat_id when invoked
## 2026-02-28 Multi-Channel Delivery Implementation

### Problem:
- When users request downloads from a group chat, results go to their private chat instead of back to the group
- System should preserve source chat context and send results back to the originating chat

### Solution Implemented:
- Added debug information to social_media_downloader.sh to show target chat ID and type
- Updated SKILL.md to document multi-channel delivery feature
- System already allows group chat ID (-5245593640) in config.json

### Testing Method:
- If command initiated from group shows "Target Chat ID: -5245593640" → Feature working correctly
- If command initiated from group shows "Target Chat ID: 207853653" → Framework routing issue

### Status:
- Ready for testing in group environment
- Will determine if issue is in framework routing or if it's already fixed## Multi-Channel Delivery Issue Identified
- When users request downloads from group chat, results are incorrectly sent to their private chat instead of back to the group
- Current behavior: All results go to private chat (207853653) regardless of source
- Issue appears to be in framework routing, not in the download skill itself
- Framework seems to automatically route responses back to user's private chat instead of preserving original chat context
- Manual message() function can successfully send to group (-5245593640), so the capability exists
- Need to find a way to preserve original chat context when processing skill requests from groups- Created cucumber care educational content in /home/balinux/.picoclaw/workspace/cucumber_care_content.txt
- Content follows Format D (Educational Article) as per agricultural skill examples
- Ready to post to Facebook when Facebook posting capability becomes available
- Content covers watering, fertilizing, weeding, pruning, support structures, pest control, and harvesting for cucumber plants## System Status 2026-03-02
- telegram-bot.service and picoclaw.service are inactive
- Heartbeat check shows system running normally despite inactive services
- Bali weather: Warm (27-31°C), end of rainy season with occasional showers
- 168 processes running, 385MB memory used, 29% disk usage
- Social media downloader skill working with multi-channel delivery