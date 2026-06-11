package io.easyware.bolao.services.push;

public record PushSendResult(boolean success, boolean subscriptionGone, String errorMessage) {
    public static PushSendResult sent() {
        return new PushSendResult(true, false, null);
    }

    public static PushSendResult gone() {
        return new PushSendResult(false, true, "Subscription is no longer valid");
    }

    public static PushSendResult failed(String errorMessage) {
        return new PushSendResult(false, false, errorMessage);
    }
}
