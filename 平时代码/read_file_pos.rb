class FilePos
  def read_fiel_by_pos
     File.open("hello.rb") do |io|
       p io.read(5)
       p io.pos
       io.pos = 0
       p io.pos
     end
  end
end


FilePos.new.read_fiel_by_pos
