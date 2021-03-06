require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "pagination" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    after { Micropost.delete_all }
    
    it { should have_selector("div.pagination") }

    it "should list each micropost" do
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_selector("li", text: micropost.content)
      end
    end
  end
  
  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_error_message("") }
      end
    end

    describe "with valid information" do

      before { fill_in "micropost_content", with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "after create a micropost" do
        before { click_button "Post" }
        it { should have_content("micropost") }
        it { should_not have_content("microposts") }

        describe "after create two microposts" do
          before do
            fill_in "micropost_content", with: "Ipsum Lorem"
            click_button "Post"
          end

          it { should have_content("microposts") }
        end
      end
    end
  end

  describe "micropost destruction" do
    let!(:micropost) { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it { should have_link("delete", href: micropost_path(micropost)) }
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

      describe "other user's micropost" do
        let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
        before { FactoryGirl.create(:micropost, user: other_user) }
        
        it { should_not have_link("delete", href: micropost_path(other_user)) }
      end
    end
  end

  describe "micropost reply" do
    let(:reply_from) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:reply_from_follower) { FactoryGirl.create(:user) }
    let!(:micropost) { FactoryGirl.create(:micropost,
                                         user: reply_from,
                                         content: "hello @#{user.login_name}") }
    let!(:unknown_micropost) { FactoryGirl.create(:micropost,
                                         user: reply_from,
                                         content: "I say to myself") }

    before do
      other_user.follow!(user)
      reply_from_follower.follow!(reply_from)
      visit root_path
    end

    it { should have_selector("li", text: micropost.content) }
    it { should_not have_selector("li", text: unknown_micropost.content) }

    describe "with other user" do
      before do
        click_link "Sign out"
        sign_in other_user
        visit root_path
      end
      
      it { should_not have_selector("li", text: micropost.content) }
      it { should_not have_selector("li", text: unknown_micropost.content) }
    end

    describe "with reply user follower" do
      before do
        click_link "Sign out"
        sign_in reply_from_follower
        visit root_path
      end
      
      it { should_not have_selector("li", text: micropost.content) }
      it { should have_selector("li", text: unknown_micropost.content) }
    end
  end
end
