require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "pagination" do
    before(:all) do
      31.times { FactoryGirl.create(:micropost, user: user) } # fix it
    end
    after(:all) { User.delete_all }

    it { should have_selector("div.pagination") }
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
end
