enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  AUTHENTICATING,
  LOGGEDOUT,
}
enum TweetType {
  Tweet,
  Detail,
  Reply,
  ParentTweet,
}
enum APIRequestStatus {
  unInitialized,
  loading,
  loaded,
  error,
  connectionError,
}

enum SortUser {
  Verified,
  Alphabetically,
  Newest,
  Oldest,
  MaxFollower,
}

enum NotificationType {
  NOT_DETERMINED,
  Message,
  Tweet,
  Reply,
  Retweet,
  Follow,
  Mention,
  Like
}
