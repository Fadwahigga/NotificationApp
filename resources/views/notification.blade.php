<form action="/send-notification" method="POST">
    @csrf
    <input type="text" name="message" placeholder="Enter your notification message">
    <button type="submit">Send Notification</button>
</form>
