class Imagec < Liquid::Tag
  # {% imagec align target image width height caption %}
  Syntax = /^\s*([lrc])\s+(\S+)\s(\S+)\s(\d+)\s(\d+)\s\"([\S\s]+)\"/
  def initialize(tagName, markup, tokens)
    super
    if markup =~ Syntax then
      @align = $1
      @target = $2
      @image = $3
      @width = $4.to_i
      @div_width = @width + 20;
      @height = $5.to_i
      @caption = $6
    end
  end

  def render(context)
    "<div class=\"imagec#{@align}\" style=\"width:#{@div_width}px\"><a href=\"#{@target}\" title=\"#{@caption}\"><img src=\"#{@image}\" width=\"#{@width}\" height=\"#{@height}\" alt=\"#{@caption}\" border=0></a><br>#{@caption}</div>"
  end

  Liquid::Template.register_tag "imagec", self
end
