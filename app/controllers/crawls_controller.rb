class CrawlsController < ApplicationController
    require 'csv'
    def index
        # agent = Mechanize.new
        # agent.user_agent_alias = 'Windows Chrome'
        # CSV.open('data.csv','wb') do |csv|
        #     for i in 1..10 do
        #         page = agent.get("https://tiki.vn/sach-truyen-thieu-nhi/c393?page=#{i}")
        #         page.links.each do |link|
        #             begin
        #                 csv << [link.href] if link.href.include? 'spid='
        #             rescue => exception 
        #             end
                    
        #         end
        #     end
        # end
        csv_text = File.read('book.csv')
        csv = CSV.parse(csv_text, :headers => false)
        names = []
        CSV.open('book2.csv', 'wb') do |file|
            csv.each_with_index do |row, index|
                name = row[0]
                if names.include? name
                    csv.delete_at(index)
                else
                    names << name
                    file << row
                end
            end
        end


    end

    def book_data
        agent = Mechanize.new
        agent.user_agent_alias = 'Windows Chrome'
        CSV.open('book1.csv', 'wb') do |csv|
            CSV.foreach('data.csv', 'r') do |rows|
                begin
                    page = agent.get("https://tiki.vn#{rows[0]}")
                    img_link = page.images[8].src
                    name = page.search("h1.title").text
                    date = ''
                    publisher = ''
                    page.search("div.has-table").search("tr").each do |row|
                        publisher = row.search('td')[1].text if row.search('td')[0].text == "Nhà xuất bản"
                        date = row.search('td')[1].text if row.search('td')[0].text == "Ngày xuất bản"
                    end
                    category_name = page.search("a.breadcrumb-item")[3].text
                    author = page.search("span.brand-and-author")[0].search("a").text
                rescue => exception
                else
                    csv << [name, date, publisher, img_link, category_name, author]  
                end
                
                
            end
        end
    end
end


#Sach tu duy
#https://tiki.vn/search?q=sach&category=871&page=1