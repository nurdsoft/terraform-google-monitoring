package alertprocessor

import (
	"context"
	"fmt"
	"log"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/cloudevents/sdk-go/v2/event"
)

func init() {
	functions.CloudEvent("ProcessAlert", ProcessAlert)
}

// ProcessAlert processes monitoring alerts from Pub/Sub
func ProcessAlert(ctx context.Context, e event.Event) error {
	log.Printf("Received alert: %s", e.ID())
	log.Printf("Alert data: %s", string(e.Data()))

	// Add your alert processing logic here
	// For example: send to Slack, PagerDuty, etc.

	return nil
}
