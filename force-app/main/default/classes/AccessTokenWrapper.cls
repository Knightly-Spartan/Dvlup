public class AccessTokenWrapper {

	public String access_token;
	public String instance_url;
	public String id;
	public String token_type;
	public String issued_at;
	public String signature;

	
	public static AccessTokenWrapper parse(String json) {
		return (AccessTokenWrapper)System.JSON.deserialize(json, AccessTokenWrapper.class);
	}
}