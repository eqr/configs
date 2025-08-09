function resize_jpegs
    set -l target_dir (test -n "$argv[1]"; and echo $argv[1]; or echo ".")
    set -l max_size (test -n "$argv[2]"; and echo $argv[2]; or echo "1920")
    
    if not command -v magick >/dev/null 2>&1
        echo "Error: ImageMagick is required but not installed"
        echo "Install with: brew install imagemagick"
        return 1
    end
    
    echo "Resizing JPEG files in $target_dir (max size: "$max_size"px)"
    
    find "$target_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while read -z -l file
        set -l original_size (stat -f%z "$file" 2>/dev/null; or echo "0")
        
        echo "Processing: $file"
        
        magick "$file" \
            -resize "$max_size"x"$max_size>" \
            -quality 85 \
            -strip \
            "$file"
        
        if test $status -eq 0
            set -l new_size (stat -f%z "$file" 2>/dev/null; or echo "0")
            set -l saved_bytes (math "$original_size - $new_size")
            if test $saved_bytes -gt 0
                echo "  ✓ Compressed: $original_size → $new_size bytes (saved: $saved_bytes)"
            else
                set -l increased_bytes (math "$new_size - $original_size")
                echo "  ✓ Processed: $original_size → $new_size bytes (increased: $increased_bytes)"
            end
        else
            echo "  ✗ Failed to process $file"
        end
    end
    
    echo "Done!"
end