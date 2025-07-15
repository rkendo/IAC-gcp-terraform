terraform{
    backend "gcs"{
        bucket = "test-bucket"
        prefix = "terraform/state"
    }
}