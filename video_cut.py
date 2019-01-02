from moviepy.video.io.ffmpeg_tools import ffmpeg_extract_subclip
from moviepy.video.io.VideoFileClip import VideoFileClip

for i in range(0,3):
    name = ["1-.avi","4-.avi","14-.avi"]
    out_name = ["1.avi","4.avi","14.avi"]
    
    clip = VideoFileClip(name[i])
    ffmpeg_extract_subclip(name[i], 0, int(clip.duration)-5, targetname=out_name[i])



