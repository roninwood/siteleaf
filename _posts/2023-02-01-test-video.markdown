---
title: test video
date: 2023-02-01 13:29:00 -05:00
published: false
---

<div class="video-widescreen">
<div id="ytplayer"></div>

<script>
  // Load the IFrame Player API code asynchronously.
  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/player_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  // Replace the 'ytplayer' element with an <iframe> and
  // YouTube player after the API code downloads.
  var player;
  function onYouTubePlayerAPIReady() {
    player = new YT.Player('ytplayer', {
      height: '560',
      width: '315',
      videoId: 'cd4-UnU8lWY'
    });
  }
</script>
