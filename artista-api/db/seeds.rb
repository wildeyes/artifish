Tag.find_or_create_by!(name: :pop_art)
Tag.find_or_create_by!(name: :kids)
Tag.find_or_create_by!(name: :commercials)
Tag.find_or_create_by!(name: :music)
Tag.find_or_create_by!(name: :movies_tv)
Tag.find_or_create_by!(name: :animals)
Tag.find_or_create_by!(name: :nature)
Tag.find_or_create_by!(name: :urban)


# Filter colors
def create_color_from_hex(hex_color)
  m = hex_color.match /#(..)(..)(..)/
  Color.find_or_create_by!(r: m[1].hex, g: m[2].hex, b: m[3].hex)
end
hex_colors = ['#bcb7b0', '#000000', '#0c2c53', '#444a6d', '#1797b8', '#00a7ed', '#0e59e1', '#2f29e7', '#7327e7', '#c55c9c', '#cd3846', '#e1947f', '#e69f55', '#efd05e', '#9abe45', '#1ec6b7', '#bdfdfc']
hex_colors.each { |hex_color| create_color_from_hex(hex_color) }
