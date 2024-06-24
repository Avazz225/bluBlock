import pathlib
import os
import instaloader
import csv
import time


target_file = 'instagram.csv'


def get_already_listed():
    basepath = pathlib.Path(__file__).parent.resolve()
    path = os.path.abspath(os.path.join(basepath, '..', '..', 'lists', target_file))
    result = []
    with open(path) as csvfile:
        for row in csvfile:
            result.append(row.split(";")[1])
    return result


def extract_comments_from_post(url, searchstr, already_listed, L):
    commentators = []
    analysed = 1
    hits = 0
    try:
        post = instaloader.Post.from_shortcode(L.context, url)
        try:
            comments = post.get_comments()
            print("Got comments from post %s" % (url))
            try:
                for comment in comments:
                    text = comment.text
                    if searchstr in text:
                        try:
                            owner = comment.owner
                            if owner.username not in already_listed:
                                try:
                                    full_name = bytes(owner.full_name.replace("Ä", 'Ae').replace("Ö", 'Oe').replace("Ü", 'Ue').replace("ä", 'ae').replace("ö", 'oe').replace("ü", 'ue').replace("ß", 'ss'), 'utf-8').decode('utf-8','ignore')
                                    if full_name == "":
                                        full_name = owner.username
                                    commentators.append({'user_id': owner.username, 'user_name': full_name, 'follower_count': owner.followers, 'private': owner.is_private, 'comment': text}) 
                                    hits += 1
                                except:
                                    print("Error during conversion of comments")
                        except:
                            print("Error during get of Owner occured, waiting for 10 seconds")
                            time.sleep(10)
                    analysed += 1
                    print("\rAnalysing comments %s\t---\tHits: %s" % (analysed, hits), end="", flush=True)
                    time.sleep(.5)
            except:
                print("\rError during get of comment text, waiting for 3 seconds")
                time.sleep(3)
        except:
            print("Error during get_comments")
    except:
        print("Error while authenticating")
    print()
    return commentators


def remove_duplicates(data):
    seen = set()
    unique_data = []
    for entry in data:
        if entry['user_id'] not in seen:
            unique_data.append(entry)
            seen.add(entry['user_id'])
    return unique_data


def qualify(data):
    qualified = []
    for entry in data:
        if entry['follower_count'] > 2500 and not entry['private']:
            entry['category'] = 2
        else:
            entry['category'] = 3
        qualified.append(entry)
    return qualified


def save(data):
    basepath = pathlib.Path(__file__).parent.resolve()
    path = os.path.abspath(os.path.join(basepath, '..', '..', 'temporary_lists', target_file))
    result = []
    with open(path, 'a', encoding="UTF-16") as csvfile:
        writer = csv.writer(csvfile, delimiter=';',quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for entry in data:
            line = [entry['user_id'], entry['user_name'], entry['category'], entry['private'], entry['follower_count'], entry['comment']]
            writer.writerow(line)
    return result


def read_target_csv():
    basepath = pathlib.Path(__file__).parent.resolve()
    path = os.path.abspath(os.path.join(basepath, '..', '..', 'temporary_lists', target_file))
    result = []
    with open(path, encoding="UTF-16") as csvfile:
        for row in csvfile:
            if row != "\n":
                res = row.split(";")[0:3]
                result.append(res)
    return result


def append_to_prod_list(targets):
    basepath = pathlib.Path(__file__).parent.resolve()
    path = os.path.abspath(os.path.join(basepath, '..', '..', 'lists', target_file))
    with open(path, "rbU") as f:
        num_lines = sum(1 for _ in f)
    with open(path, "a+") as csvfile:
        for entry in targets:
            csvfile.write("%s;%s;%s;%s\n" % (num_lines+1, entry[0], entry[1], entry[2]))
            num_lines+=1
    return