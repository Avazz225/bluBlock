import helpers
import time
import os
import instaloader
import dotenv

dotenv.load_dotenv()

posts_to_extract_comments = [
    'C8FO299JALj','C78n27zPJ8o',
    'C8EWbKoMP42','C77EIqiI3uT',
    'C8EBrOjqnck','C769YWvI_hx',
    'C8DHzoOsf_T','C762vK8NrQO',
    'C8C52UoNGKw','C76rWxms8XG',
    'C8CoSvDo93K','C74jkUVoQxC',
    'C8CNWqjoOy2','C73r1TmoWq0',
    'C8C1Bg3Iov-','C73lmj_v7uj',
    'C8CBxGDIQ-4','C710MZFo02I',
    'C8B1EploThk','C71OjgFodCU',
    'C8Bfxk1oGGb','C71Cvt2uBF9',
    'C8BlxNLuGmf','C7yvNJMIFom',
    'C8AodWqucx4','C7wmyJqpUvo',
    'C8AhXi6sPUK',
    'C8AiCzwslbL',
    'C8Af3V5s9dK',
    'C8Af5XLsKyZ',
    'C8AYXp6OJoH',
    'C8Ab53QsdQ2',
    'C8AUTkBsxQf',
    'C8AN2tSsfEz',
    'C8AJPDLMmBk',
    'C8AF-J1Mr4k',
    'C8AD1r0sdxt',
    'C8AGf2PoCLE',
    'C7_JKfJMqIh',
    'C79_kX5gCsI',
    'C79fEUtIDW_'
]

search_for = "💙"

def extract_comments():
    L = instaloader.Instaloader()
    user = os.environ.get("INSTA_USERNAME")
    password = os.environ.get("INSTA_PASSWD")
    L.login(user, password)  
    
    print("Starting extraction")
    already_listed = helpers.get_already_listed()
    comments = []
    for post in posts_to_extract_comments:
        print("Using post %s (Post %s of %s)" % (post, posts_to_extract_comments.index(post)+1, len(posts_to_extract_comments)))
        comments = helpers.extract_comments_from_post(post, search_for, already_listed, L)
        comments = helpers.remove_duplicates(comments)
        qualified_comments = helpers.qualify(comments)
        helpers.save(qualified_comments)
        for comment in qualified_comments:
            already_listed.append(comment['user_id'])
        time.sleep(20)
    
    print("Finished extraction")

if __name__ == "__main__":
    extract_comments()