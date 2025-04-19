CREATE TABLE badges (
    id INTEGER PRIMARY KEY,
    userid INTEGER,
    name TEXT,
    date TIMESTAMP,
    class SMALLINT,
    tagbased BOOLEAN
);

CREATE TABLE comments (
    id INTEGER PRIMARY KEY,
    postid INTEGER,
    score INTEGER,
    text TEXT,
    creationdate TIMESTAMP,
    userid INTEGER
);

CREATE TABLE posthistory (
    id INTEGER PRIMARY KEY,
    posthistorytypeid SMALLINT,
    postid INTEGER,
    revisionguid UUID,
    creationdate TIMESTAMP,
    userid INTEGER,
    text TEXT,
    contentlicense TEXT,
    comment TEXT
);

CREATE TABLE postlinks (
    id INTEGER PRIMARY KEY,
    creationdate TIMESTAMP,
    postid INTEGER,
    relatedpostid INTEGER,
    linktypeid SMALLINT
);

CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    posttypeid SMALLINT,
    creationdate TIMESTAMP,
    score INTEGER,
    viewcount INTEGER,
    body TEXT,
    owneruserid INTEGER,
    lastactivitydate TIMESTAMP,
    title TEXT,
    tags TEXT,
    answercount INTEGER,
    commentcount INTEGER,
    contentlicense TEXT,
    parentid INTEGER,
    lasteditoruserid INTEGER,
    lasteditdate TIMESTAMP,
    acceptedanswerid INTEGER,
    closeddate TIMESTAMP
);

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tagname TEXT,
    count INTEGER,
    isrequired BOOLEAN,
    excerptpostid INTEGER,
    wikipostid INTEGER,
    ismoderatoronly BOOLEAN
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    reputation INTEGER,
    creationdate TIMESTAMP,
    displayname TEXT,
    lastaccessdate TIMESTAMP,
    websiteurl TEXT,
    location TEXT,
    aboutme TEXT,
    views INTEGER,
    upvotes INTEGER,
    downvotes INTEGER,
    accountid INTEGER
);

CREATE TABLE votes (
    id INTEGER PRIMARY KEY,
    postid INTEGER,
    votetypeid SMALLINT,
    creationdate TIMESTAMP
);

CREATE TABLE posttags (
    postid INTEGER,
    tagid INTEGER
);

ALTER TABLE badges ADD CONSTRAINT fk_badges_userid_users_id FOREIGN KEY (userid) REFERENCES users(id);

ALTER TABLE comments ADD CONSTRAINT fk_comments_postid_posts_id FOREIGN KEY (postid) REFERENCES posts(id);
ALTER TABLE comments ADD CONSTRAINT fk_comments_userid_users_id FOREIGN KEY (userid) REFERENCES users(id);

-- удален, т.к. нет связи в Posts ((postid)=(43695))
-- ALTER TABLE posthistory ADD CONSTRAINT fk_posthistory_postid_posts_id FOREIGN KEY (postid) REFERENCES posts(id);
ALTER TABLE posthistory ADD CONSTRAINT fk_posthistory_userid_users_id FOREIGN KEY (userid) REFERENCES users(id);

ALTER TABLE postlinks ADD CONSTRAINT fk_postlinks_postid_posts_id FOREIGN KEY (postid) REFERENCES posts(id);
-- удален, т.к. нет связи в Posts ((relatedpostid)=(137542))
-- ALTER TABLE postlinks ADD CONSTRAINT fk_postlinks_relatedpostid_posts_id FOREIGN KEY (relatedpostid) REFERENCES posts(id);

-- этот ключ пришлось удалить, т.к. отсутствует пользователь в Users (OwnerUserId="288868")
-- ALTER TABLE posts ADD CONSTRAINT fk_posts_owneruserid_users_id FOREIGN KEY (owneruserid) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_posts_lasteditoruserid_users_id FOREIGN KEY (lasteditoruserid) REFERENCES users(id);
-- этот ключ пришлось удалить, т.к. есть запись на несуществующий пост AcceptedAnswerId="338217"
-- ALTER TABLE posts ADD CONSTRAINT fk_posts_acceptedanswerid_posts_id FOREIGN KEY (acceptedanswerid) REFERENCES posts(id);
ALTER TABLE posts ADD CONSTRAINT fk_posts_parentid_posts_id FOREIGN KEY (parentid) REFERENCES posts(id);

ALTER TABLE tags ADD CONSTRAINT fk_tags_excerptpostid_posts_id FOREIGN KEY (excerptpostid) REFERENCES posts(id);
ALTER TABLE tags ADD CONSTRAINT fk_tags_wikipostid_posts_id FOREIGN KEY (wikipostid) REFERENCES posts(id);

-- удален, т.к. нет связи с Posts ((postid)=(22))
-- ALTER TABLE votes ADD CONSTRAINT fk_votes_postid_posts_id FOREIGN KEY (postid) REFERENCES posts(id);

ALTER TABLE posttags ADD CONSTRAINT fk_posttags_PostId_posts_id FOREIGN KEY (PostId) REFERENCES posts(id);
ALTER TABLE posttags ADD CONSTRAINT fk_posttags_TagId_tags_id FOREIGN KEY (TagId) REFERENCES tags(id);

