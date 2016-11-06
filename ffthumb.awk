function format_video(idx,  fmt, bitrate) {
    fmt = "Stream #%d: %s, %dx%d, %s, %dkbps, %s"
    bitrate = int(streams[idx]["bit_rate"] / 1000)
    durationf = strftime("%H:%M:%S", duration, 1)
    return sprintf(fmt, idx, streams[idx]["codec_name"], streams[idx]["width"],
                   streams[idx]["height"], streams[idx]["pix_fmt"], bitrate, durationf)
}

function format_audio(idx,  fmt, bitrate) {
    fmt = "Stream #%d: %s, %s, %dkbps"
    bitrate = int(streams[idx]["bit_rate"] / 1000)
    return sprintf(fmt, idx, streams[idx]["codec_name"], streams[idx]["channel_layout"], bitrate)
}

BEGIN {
    FS = "[.=]" 
} 

/^streams/ { 
    gsub("\"", "", $5)
    streams[$3][$4] = $5
}

/^format/ {
    gsub("\"", "", $3)
    duration = $3
}

END {
    filter = ",\ndrawtext=fontcolor=white:text='%s':fontfile=%s:x=4:y=%d"
    off = 24
    for (idx in streams) {
        if (streams[idx]["width"]) {
            out = out sprintf(filter, format_video(idx), font, off)
            off += 20
        }
        if (streams[idx]["channel_layout"]) {
            out = out sprintf(filter, format_audio(idx), font, off)
            off += 20
        }
    }
    printf("pad=in_w:in_h+%d:0:%d", off, off)
    printf(filter, filename, font, 4)
    print out
}

