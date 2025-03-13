# CarRental Task

Your task here is to code a solution for description below.

- You can add any library you want
- Don't change already existing code

# Story

You work for car rental company, which has it's own database of clients. When your client is added for the first time to the system you calculate their trust score using external API which is valid for one month. Nevertheless, you don't want to do that each time you process rental, cause it takes a few minutes to process. You want to have your database up to date though. That's why you want to handle this process asynchronously every week.

Write code which updates trust score every week for all clients we have in our system.

# API limitations:

- rate limit 10 requests per minute
- endpoint can process only 100 employees (you need to group them)

# Existing interface:

You should use below functions which are interface for already existing part of a system:

- `CarRental.TrustScore.calculate_score/1` - function which returns calculated trust score for client
- `CarRental.Clients.list_clients/0` - function which returns list of clients
- `CarRental.Clients.save_score_for_client/1` - function which saves trust score for client
